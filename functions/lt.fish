# Defined in /usr/share/fish/functions/ll.fish @ line 4
function lt --wraps=ls --description 'List contents of directory using long format'
    ls -lAtr $argv
end
