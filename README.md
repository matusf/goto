# goto
A fish shell utility to quickly navigate to aliased directories supporting
tab-completion

**goto** is a port of [goto](https://github.com/iridakos/goto) to
[fish shell](https://fishshell.com/).

![demo](/demo.gif)

## Installation
### Via [fisher](https://github.com/jorgebucaran/fisher)
```
fisher add matusf/goto
```

### Manually
Simply copy the [goto.fish](https://raw.githubusercontent.com/matusf/goto/master/goto.fish)
to your `fish/functions` directory. (Typically `~/.config/fish/functions`) or run:
```
curl --create-dirs -o ~/.config/fish/functions/goto.fish https://raw.githubusercontent.com/matusf/goto/master/goto.fish
```

## Usage
### Go to an aliased directory
```
$ goto <alias>
```

### Register an alias
```
$ goto -r <alias> <directory>
$ goto --register <alias> <directory>
```

### Unregister an alias
```
$ goto -u <alias> <directory>
$ goto --unregister <alias> <directory>
```

### List aliases
```
$ goto -l
$ goto --list
```

### Cleanup non existent directory aliases
```
$ goto -c
$ goto --cleanup
```

### Expand an alias
```
$ goto -x <alias>
$ goto --expand <alias>
```

### Print a help message
```
$ goto -h
$ goto --help
```

## Features
- support for **tab-completion** (for both, options and aliases)
- works for relative as well as absolute paths
