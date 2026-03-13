#!/usr/bin/env fish 

# NVIM
set vimpath "$HOME/.config/nvim/"
echo "Moving ./nvim to $vimpath"
cp -r ./nvim/ $vimpath && sudo chown -R $USER $vimpath

# KITTY
set kittypath "$HOME/.config/kitty/"
echo "Moving ./kitty/ to $kittypath"

# FISH ======================== 
#curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
set fishpath "$HOME/.config/fish/"
echo "Moving ./fish/ to $fishpath"
cp -r ./fish/ $fishpath 
sudo chown -R $USER $fishpath
# install oh-my-fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install lavender
omf theme lavender
fisher update

# DOOM ========================
# Install
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
# ~/.config/emacs/bin/doom install
set doompath "$HOME/.config/doom/"
cp -r ./doom/ $doompath 
echo "Moving ./doom/ to $doompath"
sudo chown -R $USER $doompath
# Install the fonts for icons
git clone https://github.com/domtronn/all-the-icons.el
sudo cp all-the-icons.el/fonts/*.ttf ~/Library/Fonts/
rm -r -f all-the-icons.el
