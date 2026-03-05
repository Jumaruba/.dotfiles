#!/usr/bin/env fish 

# NVIM
set vimpath "$HOME/.config/nvim/"
echo "Moving ./nvim to $vimpath"
cp -r ./nvim/ $vimpath && sudo chown -R $USER $vimpath

# KITTY
set kittypath "$HOME/.config/kitty/"
echo "Moving ./kitty/ to $kittypath"

# FISH
#curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
set fishpath "$HOME/.config/fish/"
echo "Moving ./fish/ to $fishpath"
cp -r ./fish/ $fishpath 
sudo chown -R $USER $fishpath
omf install slacker
fisher update

