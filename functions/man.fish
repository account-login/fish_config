function man --wraps='man --nj --nh' --description 'man with sane formatting'
    # maximum columns
    set -l c 120
    if test $c -gt $COLUMNS
        set c $COLUMNS
    end

    # fish built-in man pages
    set -l manpath $MANPATH /usr/share/man
    set -l fish_manpath $__fish_data_dir/man
    if test -d $fish_manpath
        set manpath $fish_manpath $manpath
    end

    COLUMNS=$c MANPATH=$manpath command man --nj --nh $argv
end
