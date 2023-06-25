
# misc
umask 022
ulimit -c unlimited

# TTY & PTS
if tty -s
    set -g __TTY (tty)
    set -g __PTS (string replace -r '^/dev/' '' $__TTY)
end

function __have_cmd
    which $argv &>/dev/null
end

# for cmd counter in title
set -g __CMD_COUNTER 0
set -g __CMD_PWD $PWD

# hooks
function __on_preexec --on-event fish_preexec
    set __CMD_COUNTER (math $__CMD_COUNTER + 1)
    set __CMD_PWD $PWD

    # right prompt
    set -l up (count (string split \n $argv))   # XXX: can not deal with long line
    set up (math $up + 1)   # prompt is 2 line
    echo -ens '\e[s\e['$up'A\e[9999C\e[28D' (printf " %04d " $__CMD_COUNTER) (command date +'%Y-%m-%d %H:%M:%S.%3N') '\e[u'
end

function __on_postexec --on-event fish_postexec
    # backup histories
    set -l status_text (string join '|' $pipestatus)
    echo (
        echo (__ts_fmt)
        printf "% 11s " [pid:$fish_pid]
        echo [pwd:$__CMD_PWD]
        printf "% 12s " [dur:{$CMD_DURATION}ms]
        echo [status:$status_text]
        echo $argv
    ) >>~/.fish_history.log
end

# no welcome message
set fish_greeting

# python output encoding
set -gx PYTHONIOENCODING utf-8

# override all LC_* options
set -ge LANG LANGUAGE LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES; or true
set -gx LC_ALL C.UTF-8      # the saner locale

# aliases
alias ....='cd ../..'
alias md='mkdir -pv'
alias du1='du --max-depth=1 -h -a -x'
alias g="grep -P"

# Some more alias to show mistakes:
alias rm='rm -v --one-file-system'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'
alias rd='rm -rfv --one-file-system'

alias chmod='chmod --preserve-root --changes'
alias chown='chown --preserve-root --changes'
alias chgrp='chgrp --preserve-root --changes'

alias ngrep='ngrep -W byline -e -qt'
alias ng=ngrep
alias tcpdump='tcpdump -n -B 4096'
alias myip='dig +short myip.opendns.com @resolver1.opendns.com -4'
alias ping='ping -n'

# pager
set -gx PAGER "more"
if __have_cmd less
    set PAGER "less"
    # display color and verbose prompt
    set -gx LESS "-R -M"
    # tabstop=4
    set LESS "$LESS -x4"
    # quit if the entire file can be displayed on the first screen
    set LESS "$LESS --quit-if-one-screen"
end
# unicode support for less
set -gx LESSCHARSET utf-8

# termcap terminfo
# mb      blink     start blink
# md      bold      start bold
# me      sgr0      turn off bold, blink and underline
# so      smso      start standout (reverse video)
# se      rmso      stop standout
# us      smul      start underline
# ue      rmul      stop underline

# less colors
set -gx LESS_TERMCAP_mb (echo -ne '\e[1;31m')
set -gx LESS_TERMCAP_md (echo -ne '\e[1;31m')
set -gx LESS_TERMCAP_me (echo -ne '\e[0m')
set -gx LESS_TERMCAP_se (echo -ne '\e[0m')
set -gx LESS_TERMCAP_so (echo -ne '\e[0;30;48;5;118m')
set -gx LESS_TERMCAP_ue (echo -ne '\e[0m')
set -gx LESS_TERMCAP_us (echo -ne '\e[1;4;33m')
set -gx GROFF_NO_SGR 1   # for colored man pages

# ls colors
set -gx LS_COLORS 'tw=34:ow=34:st=34:'  # no unreadable bg

# git aliases
alias gits='git status'
alias gitamend='git commit -a --amend --no-edit'
alias gitd='git diff'
alias gitl='git log'

# colordiff
__have_cmd colordiff && alias diff='colordiff'

# PATH
# NOTE: do not use fish_add_path to avoid adding PATH to .config/fish/fish_variables
function add_path -d 'prepend to PATH'
    set -l p
    for p in $argv
        if contains -i $p $PATH &>/dev/null
            set -ge PATH[(contains -i $p $PATH)]
        end
        set -gx PATH $p $PATH
    end
end

function rm_path -d 'remove from PATH'
    for p in $argv
        if contains -i $p $PATH &>/dev/null
            set -ge PATH[(contains -i $p $PATH)]
        end
    end
end

# remove PATH from .config/fish/fish_variables
set -Ue PATH
# customize PATH
if test -d ~/scripts
    add_path ~/scripts
end
if test -d ~/bin
    add_path ~/bin
end
# standard paths
# /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# NOTE: the order of paths is important, some cmd like cmake can not be invoked from /bin
add_path /bin
add_path /sbin
add_path /usr/bin
add_path /usr/sbin
add_path /usr/local/bin
add_path /usr/local/sbin

# tabstop=4
tabs 4 &>/dev/null

# colors
set -g COLOR_YELLOW (echo -ne '\e[1;33m')
set -g COLOR_RED (echo -ne '\e[1;31m')
set -g COLOR_GREEN (echo -ne '\e[1;32m')
set -g COLOR_BRIGHT (echo -ne '\e[97;40m')
set -g COLOR_GREY_BG (echo -ne '\e[48;2;40;40;40m')
set -g COLOR_NO (echo -ne '\e[m')

# display host name, overridable
set -g ALTHOSTNAME $hostname

# for windows
if test (uname -o) = Cygwin
    rm_path /bin    # /bin is same as /usr/bin on cygwin

    # open explorer
    function e
        if test 0 = (count $argv)
            cygstart --maximize --explore .
        else
            set -l v ''
            for v in $argv
                cygstart --maximize --explore "$v"
            end
        end
    end

    # notepad
    function np
        cygstart notepad (cygpath -w $argv)
    end

    # vscode
    if __have_cmd code
        function code
            command code (cygpath -w -- $argv)
        end
    end

    alias rg='rg --path-separator=/ --cygwin-path'
    alias fd='fd --path-separator=/ --cygwin-path'
end

# site specific config
if test -f ~/site.fish
    . ~/site.fish
end
