# dotfiles

```
echo "diff-so-fancy" Configs"
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global color.ui true
git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"
git config --global color.diff.meta       "yellow"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"

git clone git@github.com:satrun77/dotfiles.git ~/workspace/dotfiles

install.sh
```

## Dependencies
- [moo-command](http://github.com/satrun77/moo-command)
- [Prezto — Instantly Awesome Zsh](https://github.com/sorin-ionescu/prezto)
- [BAT](https://github.com/sharkdp/bat#installation)
- [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)
- Homebrew:
    - diff-so-fancy
    - wget
    - fontconfig
    - n
    - jmeter
    - unison
    - git
    - php-cs-fixer
    - php
    - yarn
    - mkcert
    - git-gui
    - node
    - chromedriver
    - composer
    - phpcpd
    - phpmd
    - phpize
    - phpdbg
    - phar
