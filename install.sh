#!/bin/bash

# TODO(joschnei): Give people an arbitrary install directory. Maybe this should be a makefile.

PATHS=($HOME/bin $HOME/.local/bin /usr/local/bin)

for INSTALL_DIR in $PATHS; do
  if [[ ":$PATH:" == *":INSTALL_DIR:"* ]]; then
    break
  fi
done

# echo $INSTALL_DIR

ln -s $(pwd)/setup.sh $INSTALL_DIR/git-setup