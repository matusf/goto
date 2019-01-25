function __goto_usage
    printf "\
 usage: goto [<option>] <alias> [<directory>]

 default usage:
    goto <alias> - changes to the directory registered for the given alias

 OPTIONS:
    -r, --register: registers an alias
      goto -r|--register <alias> <directory>
    -u, --unregister: unregisters an alias
      goto -u|--unregister <alias>
    -l, --list: lists aliases
      goto -l|--list
    -x, --expand: expands an alias
      goto -x|--expand <alias>
    -c, --cleanup: cleans up non existent directory aliases
      goto -c|--cleanup
    -h, --help: prints this help
      goto -h|--help\n"
end

function __goto_resolve_db
    set -g GOTO_DB "$HOME/.goto"
    touch -a $GOTO_DB
end

function __goto_register
    if test (count $argv) -lt 3
        echo 'usage: goto -r|--register <alias> <directory>'
        return 1
    end
    set acronym $argv[2]
    set directory $argv[3]

    if not test (string match -r '^[\d\w_]+$' $acronym)
        echo "Invalid alias: '$acronym'. Alises can contain only letters, \
digits and underscores."
        return 1
    end

    if not test -d $directory
        echo "Directory: '$directory' does not exists."
        return 1
    end

    if test (__goto_find_directory $acronym) != ''
        echo "Alias already exists."
        return 1
    end

    echo $acronym (realpath $directory) >> $GOTO_DB
    if test $status -eq 0
        echo 'Alias successfully registered.'
    else
        echo 'Unable to register alias.'
        return 1
    end
end

function __goto_find_directory
    echo (cat $GOTO_DB | string match -r "^$argv (.+)\$")[2]
end

function __goto_directory
    set directory (__goto_find_directory $argv)

    if test $directory = ""
        echo "Alias: '$argv' not found."
        return 1
    end

    cd $directory ^ /dev/null
    if test $status -ne 0
        echo "Failed to goto: '$directory'."
        return 1
    end
end

function __goto_list
    cat $GOTO_DB
end

function __goto_unregister
    if test (count $argv) -lt 2
        echo 'usage: goto -u|--unregister <alias>'
        return 1
    end
    set acronym $argv[2]
    set tmp_db $HOME/.goto_tmp
    cat $GOTO_DB | string match -r "^(?!$acronym ).+" > $tmp_db
    mv $tmp_db $GOTO_DB
    echo 'Alias successfully unregistered.'
end

function __goto_expand
    if test (count $argv) -lt 2
        echo 'usage: goto -x|--expand <alias>'
        return 1
    end
    echo (__goto_find_directory $argv[2])
end

function __goto_cleanup
    set tmp_db $HOME/.goto_tmp
    touch $tmp_db
    for line in (cat $GOTO_DB)
        if test -d (realpath (string split ' ' $line)[2])
            echo $line >> $tmp_db
        else
            set acronym (string split ' ' $line)[1]
            echo "Removing: '$acronym'."
        end
    end
    mv $tmp_db $GOTO_DB
end

function goto -d 'quickly navigate to aliased directories'
    if test (count $argv) -lt 1
        __goto_usage
        return 1
    end
    __goto_resolve_db
    switch $argv[1]
        case -r or --register
            __goto_register $argv
        case -u or --unregister
            __goto_unregister $argv
        case -l or --lists
            __goto_list
        case -x or --expand
            __goto_expand $argv
        case -c or --cleanup
            __goto_cleanup
        case -h or --help
            __goto_usage
        case '*'
            __goto_directory $argv[1]
    end
    return $status
end

# goto completions
complete -c goto -x -a "(cat $HOME/.goto | string match -r '.+?\b')"
complete -c goto -x -s u -l unregister -d "unregister an alias" \
         -a "(cat $HOME/.goto | string match -r '.+?\b')"
complete -c goto -x -s x -l expand -d "expands an alias" \
         -a "(cat $HOME/.goto | string match -r '.+?\b')"
complete -c goto -x -s r -l register -d "register an alias"
complete -c goto -x -s h -l help -d "prints help message"
complete -c goto -x -s l -l list -d "lists aliases"
complete -c goto -x -s c -l cleanup -d "deletes non existent directory aliases"
