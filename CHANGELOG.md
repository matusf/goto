# Changelog

## 1.1.1 - 16/02/20
### Changed
- allow hyphens in aliases

## 1.1.0 - 19/06/19
### Changed
- `goto --list` prints sorted tab separated table

## 1.0.0 - 15/02/19
### Added
- version option
- environment variable (`GOTO_DB`) to configure goto db location

### Changed
- `goto` now follows XDG directory specification. The location of db has changed
from `$HOME/.goto` to `$XDG_DATA_HOME/goto/db`. You can migrate by running
`cat $HOME/.goto > (__goto_get_db)`


## 0.1.0 - 31/01/19
### Added
- goto command
- register, unregister, cleanup, list, expand, help options
- tab completions
