
if status is-interactive
    # Commands to run in interactive sessions can go here 
    set PATH ~/.cargo/bin $PATH  
    set PATH ~/bin/ $PATH
    set PATH ~/gradle/bin/ $PATH
    set PATH ~/.local/bin/ $PATH
end

# Github alias
alias ghpr "gh pr checkout"
 
alias assume "source /opt/homebrew/bin/assume.fish"

# aliases for EZA 
alias ll "eza -l -g --icons"
alias lla "ll -a"
alias llt "ll --tree" 
alias llat "lla --tree"

# aliases for Github
alias gs "git status -s"


# theme
set -g theme_nerd_fonts yes
set -g theme_display_git_dirty yes
set -g theme_title_display_path yes

# sbt pipeline
alias sbt_check "sbt compile && sbt scalafmt && sbt test:scalafmt && sbt test"
function sbt_failures
    set tmp (mktemp)
    sbt test 2>&1 | tee $tmp >/dev/null

    set failures (grep -E "(! |✗|FAILED)" $tmp)

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

