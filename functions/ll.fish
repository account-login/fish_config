# Defined in /usr/share/fish/functions/ll.fish @ line 4
function ll --wraps=ls --description 'List contents of directory using long format'
    ls -lA $argv
end
