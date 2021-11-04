# Defined in /usr/share/fish/functions/fish_title.fish @ line 1
function fish_title
    echo $__PTS@$ALTHOSTNAME:(__my_pwd) \($__CMD_COUNTER\)
end
