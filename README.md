# git-setup
Git subcommand to do common setup tasks for python projects

Usage:
    git setup [GIT_URL] [CONDA_PACKAGES]

Example:
    git setup git@github.com:python/mypy.git python==3.7 black pylint

# Installation
```bash
chmod +x install.sh
./install.sh
```

This repo installs to $HOME/bin, $HOME/.local/bin, or /usr/local/bin. If you want to install somewhere else, you just need a symlink to git-setup.sh somewhere in your path. See [here](https://github.com/git/git/blob/master/Documentation/howto/new-command.txt) for details on git subcommands.

# Details

This repo provides a git subcommand which performs the following common tasks:

1. Clones the repository into the current directory
1. Creates a conda environment for that repository from environment.yml if it exists
1. Installs further packages through conda if provided
1. Installs further packages through pip if requirements.txt exists
1. Installs the cloned repository through pip if possible.
1. Creates a tmuxinator environment for the package from the provided template.