#!/bin/bash

# Config

# Credit https://gist.github.com/pkuczynski/8665367
parse_yaml() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}
eval $(parse_yaml ~/config.yml "config_")

MYWORKSPACE=$config_myworkspace

# Path

export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:$PATH
export PATH=~/.composer/vendor/bin/:$PATH

# Colors

NC='\033[0m' # No Color
RED='\033[0;31m'
CYAN="\033[36m"
BLACK="\033[30m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PINK="\033[35m"
WHITE="\033[37m"

# Aliases

message() {
    printf "${1}${2}${NC}\n"
}

message_error() {
    printf "${RED}${1}${NC}\n"
}

alias selen="java -jar ~/selenium-server-standalone.jar"

deepspace() {
    if [ "$1" = "help" ]
    then
        message ${YELLOW} "SSH into vagrant"
        exit;
    fi
    cd $MYWORKSPACE && vagrant ssh
}

workspace() {
    if [ "$1" = "help" ]
    then
        message ${YELLOW} "Execute vagrant up/down/distory/..."
        exit;
    fi
    cd $MYWORKSPACE
    vagrant ${1-up}
    osascript -e 'display notification "Workspace $1 complete!" with title "Workspace"'
}

updatespace() {
    if [ "$1" = "help" ]
    then
        message ${YELLOW} "Execute vagrant provision"
        exit;
    fi
    cd $MYWORKSPACE
    vagrant provision
    osascript -e 'display notification "Workspace provision complete!" with title "Workspace"'
}

changespace() {
    if [ "$1" = "help" ]
    then
        message ${YELLOW} "Open to edit workspace environment config"
        exit;
    fi
    vim $MYWORKSPACE/config/environment.yaml
}

createplanet() {
    if [ "$1" = "help" ]
    then
        message ${YELLOW} "Create a new planet (site) [name] [title]"
        exit;
    fi
    cd $MYWORKSPACE
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
        message_error "Error... directory already exists."
    fi
}

destroyplanet() {
    if [ "$1" = "help" ]
    then
        message ${YELLOW} "Distroy a planet (site)"
        exit;
    fi
    cd $MYWORKSPACE/public
    rm -rf $1
    updatespace
}

whoisusingport() { lsof -i tcp:$* }

searchphpmodule() { php -m | grep -e"$1" }

phpfixer() {
    if [ "$1" = "help" ]
    then
        message ${YELLOW} "Standard php-cs-fixer for OOP projects"
        exit;
    fi

    for var in "$@"
    do
        message ${CYAN} "Fixing: $var"
        message ${YELLOW} "------------------------------"
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

# Local customisation...
local_file=$HOME/.local_profile
if [ -f "$local_file" ]
then
	source $local_file
fi
