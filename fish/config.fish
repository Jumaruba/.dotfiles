
if status is-interactive
    # Commands to run in interactive sessions can go here 
    set PATH ~/.cargo/bin $PATH  
    set PATH ~/bin/ $PATH
    set PATH ~/gradle/bin/ $PATH
    set PATH ~/.local/bin/ $PATH
end

# aliases for EZA  ======
alias ll "eza -l -g --icons"
alias lla "ll -a"
alias llt "ll --tree" 
alias llat "lla --tree"

# aliases for Github ======
alias ghs "git status -s"
alias ghlog "git log --graph --decorate \
--pretty=format:'%C(auto)%h%C(reset) %C(cyan)%s%C(reset) %C(dim white)- %an, %ar%C(reset)'"
alias ghpr "gh pr checkout"
alias assume "source /opt/homebrew/bin/assume.fish"

# theme ======
set -g theme_nerd_fonts yes
set -g theme_display_git_dirty yes
set -g theme_title_display_path yes

# sbt pipeline ======
function sbt_failures
    set tmp (mktemp)
    sbt test 2>&1 | tee $tmp >/dev/null

    set failures (grep -E "(! |✗|FAILED|\[error\])" $tmp)

    if test (count $failures) -eq 0
        set_color green
        echo "✓ All tests passed"
        set_color normal
    else
        set_color red
        echo "Failing tests:"
        set_color normal

        for f in $failures
            set_color yellow
            echo "✗ "(string trim $f)
            set_color normal
        end
    end

    rm $tmp
end

alias sbt_check "sbt compile && sbt scalafmt && sbt test:scalafmt && sbt_failures"

# terminal ====== 
function reload
    source ~/.config/fish/config.fish
end
