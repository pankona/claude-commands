#!/bin/bash -x

# cp commands
mkdir -p $HOME/.claude/commands
cp commands/* $HOME/.claude/commands/.

# install convenience scripts
mkdir -p $HOME/bin
cp bin/* $HOME/bin/.
