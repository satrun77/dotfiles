
# Path

export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:$PATH
export PATH=~/.composer/vendor/bin/:$PATH


# Aliases

alias selen="java -jar ~/selenium-server-standalone.jar"

deepspace() {
    if [ "$1" = "help" ]
    then
        echo "SSH into vagrant"
        exit;
    fi
    cd ~/Desktop/WWW/workspace && vagrant ssh
}

workspace() {
    if [ "$1" = "help" ]
    then
        echo "Execute vagrant up/down/distory/..."
        exit;
    fi
    cd ~/Desktop/WWW/workspace
    vagrant ${1-up}
    osascript -e 'display notification "Workspace " + $1 + " complete!" with title "Workspace"'
}

updatespace() {
    if [ "$1" = "help" ]
    then
        echo "Execute vagrant provision"
        exit;
    fi
    cd ~/Desktop/WWW/workspace
    vagrant provision
    osascript -e 'display notification "Workspace provision complete!" with title "Workspace"'
}

changespace() {
    if [ "$1" = "help" ]
    then
        echo "Open to edit workspace environment config"
        exit;
    fi
    vim ~/Desktop/WWW/workspace/config/environment.yaml
}

createplanet() {
    if [ "$1" = "help" ]
    then
        echo "Create a new planet (site) [name] [title]"
        exit;
    fi
    cd ~/Desktop/WWW/workspace
    DIRECTORY="public/$1"
    if [ ! -d "$DIRECTORY" ]; then
        mkdir public/$1
        cat > public/$1/.dashbrew <<- EOM
---
$1.dev:
  title: $2
  php:
    build: system
  vhost:
    servername: $1.dev
    serveraliases:
      - www.$1.dev

EOM
        updatespace
    else
        RED='\033[0;31m'
        NC='\033[0m' # No Color
        printf "${RED}Error... directory already exists.${NC}\n"
    fi
}

destroyplanet() {
    if [ "$1" = "help" ]
    then
        echo "Distroy a planet (site)"
        exit;
    fi
    cd ~/Desktop/WWW/workspace/public
    rm -rf $1
    updatespace
}

whoisusingport() { lsof -i tcp:$* }

searchphpmodule() { php -m | grep -e"$1" }

phpfixer() {
    if [ "$1" = "help" ]
    then
        echo "Standard php-cs-fixer for OOP projects"
        exit;
    fi

    for var in "$@"
    do
        echo "\nFixing: $var"
        echo "------------------------------"
        php-cs-fixer fix $var --fixers=-concat_without_spaces,-phpdoc_no_empty_return,-phpdoc_short_description --verbose
    done
    osascript -e 'display notification "Standard PHP Fixer complete!" with title "PHP fixer"'
}

helpme() {
    echo "deepspace:\t" `deepspace help`
    echo "workspace:\t" `workspace help`
    echo "updatespace:\t" `updatespace help`
    echo "changespace:\t" `changespace help`
    echo "createplanet:\t" `createplanet help`
    echo "destroyplanet:\t" `destroyplanet help`
    echo "phpfixer:\t" `phpfixer help`
    echo "whoisusingport:"
    echo "searchphpmodule:"
}
