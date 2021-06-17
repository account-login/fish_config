# for title and prompt
function __my_pwd
    set -l realhome ~
    echo (string replace -r '^'"$realhome"'($|/)' '~$1' $PWD)
end
