# Defined in /usr/share/fish/functions/ls.fish @ line 20
function ls --description 'List contents of directory'
    command ls --color=auto --time-style="+%Y-%m-%d %H:%M:%S" -v $argv
end
