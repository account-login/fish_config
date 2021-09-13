# Defined in /usr/share/fish/vendor_functions.d/fish_prompt.fish @ line 4

# prompt_iamroot is supplied by cygwin, define this for linux
if not type -q prompt_iamroot
    if test (id -u) = 0
        function prompt_iamroot
            echo yes
        end
    else
        function prompt_iamroot
            echo no
        end
    end
end

function __prompt_pipe_status
    # COLOR_BRIGHT is causing problem
    set -l color_true_white $COLOR_NO(echo -ne '\e[38;2;255;255;255m')
    set -l t $color_true_white'['
    set -l sep ''
    for x in $argv
        if test $x = 0
            set t $t$sep$COLOR_GREEN'0'
        else
            set t $t$sep$COLOR_RED$x$color_true_white
            if test $x -gt 128
                set t $t$color_true_white:$COLOR_YELLOW(fish_status_to_signal $x)
            end
        end
        set sep $color_true_white'|'
    end
    set t $t$color_true_white']'
    echo $t
end

function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus

    # Set the prompt differently when we're root
    set -l suffix '$ '
    if test (prompt_iamroot) = yes
        set suffix '￥'
    end

    # Write pipestatus
    set -l prompt_status $COLOR_BRIGHT'@'$COLOR_NO
    set -l x 0
    for x in $last_pipestatus
        if test $x != 0
            break
        end
    end
    if test $x != 0
        set prompt_status (__prompt_pipe_status $last_pipestatus)
        set prompt_status (string replace -a SIG '' -- $prompt_status)
    end

    set -l level
    if test $SHLVL != 1
        set level ' '[$SHLVL]
    end

    echo -n -s $COLOR_YELLOW "$USER" $COLOR_NO \
        $prompt_status \
        $COLOR_GREEN $ALTHOSTNAME $COLOR_NO \
        $COLOR_BRIGHT ':' $COLOR_NO \
        $COLOR_GREEN (__my_pwd) $COLOR_NO \
        $level \
        (fish_vcs_prompt) $COLOR_NO \
        ' ' $COLOR_GREY_BG \033 [K \n $COLOR_NO \
        $COLOR_BRIGHT $suffix $COLOR_NO
end
