function rcode
    set -l tuple (string split ' ' -- $SSH_CONNECTION)
    set -l client $tuple[1]
    set -l server $tuple[3]
    for proj in $argv
        set -l proj (realpath $proj)
        ssh $client command code --folder-uri "vscode-remote://ssh-remote+$server/$proj" &
    end
end
