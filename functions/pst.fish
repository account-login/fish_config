# pstree
function pst --wraps=pstree --description pstree
    pstree -halGp $argv |command grep --color=never -oP '^.*\S(?=\s*$)'
end
