# Defined in /usr/share/fish/vendor_functions.d/fish_prompt.fish @ line 4
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
        set prompt_status (__fish_print_pipestatus "[" "]" "|" $COLOR_BRIGHT $COLOR_RED $last_pipestatus)
    end

    echo -n -s $COLOR_YELLOW "$USER" $COLOR_NO \
        $prompt_status \
        $COLOR_GREEN (prompt_hostname) $COLOR_NO \
        $COLOR_BRIGHT ':' $COLOR_NO \
        $COLOR_GREEN (__my_pwd) $COLOR_NO \
        (fish_vcs_prompt) $COLOR_NO \
        $COLOR_BRIGHT \n $suffix $COLOR_NO
end
