
if status is-interactive
    # Commands to run in interactive sessions can go here 
    set PATH ~/.cargo/bin $PATH  
    set PATH ~/bin/ $PATH
    set PATH ~/gradle/bin/ $PATH	
end

# Github alias
alias ghpr "gh pr checkout"
alias assume "source /opt/homebrew/bin/assume.fish"

# aliases 
alias ll "eza -l -g --icons"
alias lla "ll -a"
alias llt "ll --tree" 
alias llat "lla --tree"

# theme
set -g theme_nerd_fonts yes
set -g theme_display_git_dirty yes
set -g theme_title_display_path yes

# sbt pipeline
alias sbt_check "sbt compile && sbt scalafmt && sbt test:scalafmt && sbt test"
