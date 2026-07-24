# Usage 

To compile the markdown using pandoc, you can use this command:

```
pandoc lala.md \
        --template "$HOME/dotfiles/dotfiles/.config/doom/pandoc/template/doc.html" \
        -V TP_DIR="$HOME/dotfiles/dotfiles/.config/doom/pandoc/third_party" \
        -V TPL_DIR="$HOME/dotfiles/dotfiles/.config/doom/pandoc/template" \
        -o file.html
```
