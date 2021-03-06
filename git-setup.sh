#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")

echo "Cloning git repo"
git clone $1
BASEDIR="$(basename "$1" .git)"
cd $BASEDIR

DIR=$(pwd)

echo "Setting up conda env"
if [ -f environment.yml ]; then
    ENV=$(conda env create -f environment.yml --json -q | jq -r .prefix | xargs basename)
else
    conda create --name $BASEDIR -y
    ENV=$BASEDIR
fi

# Set enviornment variables to let conda know we've set it up for use in bash
eval "$(command conda 'shell.bash' 'hook')"
conda activate $ENV

PACKAGES="${@:2}"
if [ -z PACKAGES ]; then
    conda install $PACKAGES
fi

# We use $env as to the overall project name, when it disagrees with the directory name


if ! [[ $(which python) == *"$ENV"* ]]; then
    echo "No python specified, installing default"
    conda install python -y
fi

echo "Installing pip packages"
python -m pip install --upgrade pip

if compgen -G "*requirements*.txt" > /dev/null; then
    for REQ in *requirements*.txt; do
        python -m pip install -r "$REQ"
    done
fi

if [ -f setup.py ]; then
    # This will often fail, because you need to install requirements not covered by environment.yml
    # or requirements.txt. It'll work often enough that I want to keep it, but when it fails
    # I don't want it polluting everything. 
    python -m pip install -e . &> /dev/null
fi

echo "Setting up tmuxinator"
if [ -x "$(command -v tmuxinator)" ]; then
    echo "Creating tmuxinator environment"
    CONFIG_PATH=$DIR/.tmuxinator.yml
    cat $SCRIPT_DIR/template.yml \
    | sed -e 's:{ENV\}:'$ENV':'  \
          -e 's:{DIR\}:'$DIR':' \
          -e 's:{CONFIGPATH\}:'$CONFIG_PATH':' \
    &> .tmuxinator.yml
    tmuxinator start $ENV
else
    echo "tmuxinator not found"
fi

