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

whoisusingport() { lsof -i tcp:$* }

searchphpmodule() { php -m | grep -e"$1" }

helpme() {
    echo "whoisusingport:"
    echo "searchphpmodule:"
}

# Local customisation...
local_file=$HOME/.local_profile
if [ -f "$local_file" ]
then
    source $local_file
fi
