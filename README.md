# Dotfiles

Run the following script for installation:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/brianvanburken/dotfiles/master/install.sh)"
```

## How to use

After installation you can edit and add dotfiles like so:

```bash
$ config status
$ config add .vimrc
$ config commit -m "Add vimrc"
$ config add .config/redshift.conf
$ config commit -m "Add redshift config"
$ config push
```

*NOTE*: `config` is just an alias for git but set to work on the ROOT directory
(for OSX/macOS this is $HOME)
