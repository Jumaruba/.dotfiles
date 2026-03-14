#!/usr/bin/env fish

# Usage: install.fish [module...]
# Modules: nvim fish kitty doom ghostty packages
# Default: installs all modules

function install_config -a name src dest
    echo "Installing $name: $src -> $dest"
    cp -r $src $dest && sudo chown -R $USER $dest
end

function module_nvim
    install_config nvim ./nvim/ $HOME/.config/nvim/
end

function module_fish
    install_config fish ./fish/ $HOME/.config/fish/
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
    omf install lavender && omf theme lavender
    fisher update
end

function module_kitty
    install_config kitty ./kitty/ $HOME/.config/kitty/
end

function module_doom
    install_config doom ./doom/ $HOME/.config/doom/
    git clone https://github.com/domtronn/all-the-icons.el
    sudo cp all-the-icons.el/fonts/*.ttf $HOME/Library/Fonts/
    rm -rf all-the-icons.el
end

function module_ghostty
    install_config ghostty ./ghostty/ "$HOME/Library/Application Support/com.mitchellh.ghostty/"
end

function module_packages
    fish packages.fish
end

set -l all_modules nvim fish kitty doom ghostty packages
set -l modules $argv

if test (count $modules) -eq 0
  echo "Installing all modules"
  set modules $all_modules
end 

for m in $modules
    if contains $m $all_modules
        module_$m
    else
        echo "Unknown module: $m (available: $all_modules)"
        exit 1
    end
end
