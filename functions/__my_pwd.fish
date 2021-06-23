# for title and prompt
function __my_pwd
    set -l realhome ~
    set -l prefix_len (string length -- $realhome)
    set -l pwd $PWD
    if test $realhome = (string sub -l $prefix_len -- $pwd)
        set pwd '~'(string sub -s (math 1 + $prefix_len) $pwd)
    end
    echo $pwd
end
