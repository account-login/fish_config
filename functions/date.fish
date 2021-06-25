function date --wraps=date --description 'date command with sane format'
    # Usage: date [OPTION]... [+FORMAT]
    #   or:  date [-u|--utc|--universal] [MMDDhhmm[[CC]YY][.ss]]

    set -l add_format 1
    set -l v
    for v in $argv
        switch $v
        case -u --utc --universal '+*'
            set add_format 0
            break
        end
    end
    if test $add_format = 1
        set argv $argv '+%Y-%m-%d_%H:%M:%S.%3N'
    end
    command date $argv
end
