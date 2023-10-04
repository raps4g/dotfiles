#!/bin/bash
dotfiles=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mkdir -p $HOME/.local/share/fonts/
mkdir -p $HOME/.themes/
mkdir -p $HOME/.local/share/backgrounds/
cp -rv $dotfiles/fonts/* $HOME/.local/share/fonts/
cp -rv $dotfiles/themes/* $HOME/.themes/
cp -rv $dotfiles/wallpapers/* $HOME/.local/share/backgrounds/
