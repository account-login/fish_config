# pstree
function pst --wraps=pstree --description pstree
    pstree -halGp $argv |grep --color=never -oP '^.*\S(?=\s*$)'
end
