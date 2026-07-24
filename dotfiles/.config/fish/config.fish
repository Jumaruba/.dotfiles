
if status is-interactive
    # Commands to run in interactive sessions can go here 
    set PATH ~/.cargo/bin $PATH  
    set PATH ~/bin/ $PATH
    set PATH ~/gradle/bin/ $PATH
    set PATH ~/.local/bin/ $PATH

    # Work scripts
    set PATH ~/Documents/relevancy-generator/scripts/launchers/ $PATH
    set PATH ~/Documents/relevancy-generator/scripts/bash/ $PATH

    set -x TERRAPRISM_TOFU 1
end

# aliases for EZA  ======
alias ll "eza -l -g --icons"
alias lla "ll -a"
alias llt "ll --tree" 
alias llat "lla --tree"

# aliases for Github ======
alias ghlog "git log --graph --decorate --pretty=format:'%C(auto)%h%C(reset) %C(cyan)%s%C(reset) %C(dim white)- %an, %ar%C(reset)'"
alias ghpr "gh pr checkout"
alias assume "source /opt/homebrew/bin/assume.fish"

alias tp "terraprism"

# theme ======
set -g theme_nerd_fonts yes
set -g theme_display_git_dirty yes
set -g theme_title_display_path yes

# SBT Pipeline ====== 
function run-tests
  set name $argv[1]
  sbt compile && sbt scalafmt && sbt test:scalafmt && sbt "testOnly *$name" && sbt -v --batch it/test
end

# Terminal ==========================
function reload
    source ~/.config/fish/config.fish
end

# PICKS ==========================
set scripts \
    run-s3 \
    run-dynamodb \
    run-postgres \
    pblcat

set sbtcommand \
    "sbt relevancy-generator/compile" \
    "sbt relevancy-generator/test" \
    "sbt event-predictors/test" \
    "sbt relevancy-generator-feature-extractor/compile" \
    "sbt relevancy-generator-feature-extractor/test" \
    "sbt relevancy-generator-feature-extractor/reStartConf" \
    "sbt relevancy-generator-it/test"

bind \cs 'pick-display scripts'

bind \cf 'pick-display sbtcommand'

function pick-display
  # Creating the list to be displayed
  set list_name $argv[1]

  # Display and execute
  set selected (printf "%s\n" $$list_name | peco)
  
  if test -n "$selected"
    commandline -i -- $selected
  end
end

