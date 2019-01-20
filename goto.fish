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
     return 1
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

    echo $acronym (realpath $directory) >> $GOTO_DB
    if $status -eq 0
        echo 'Alias successfully registered.'
    else
        echo 'Unable to register alias.'
    end
end

function goto
    if test (count $argv) -lt 1
        __goto_usage
    end
    __goto_resolve_db
    switch $argv[1]
        case -r or --register
            __goto_register $argv
        case -u or --unregister
            echo -u
        case -h or --help
            __goto_usage
        case '*'
            __goto_directory $argv[1]
    end
    return $status
end

goto $argv
