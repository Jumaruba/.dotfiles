if status is-interactive
    # Commands to run in interactive sessions can go here 
    set PATH ~/neovim/build/bin $PATH
    set PATH ~/.cargo/bin $PATH  
	set PATH ~/libgit2/ $PATH
    set PATH ~/miniconda3/bin/ $PATH 
    set PATH ~/bin/ $PATH
end

# aliases 
alias ll "exa -l -g --icons"
alias lla "ll -a"
alias llt "ll --tree" 
alias llat "lla --tree"

# theme
set -g theme_nerd_fonts yes
set -g theme_display_git_dirty yes
set -g theme_title_display_path yes
