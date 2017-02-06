#!/bin/bash

# Path

export PATH=~/.composer/vendor/bin/:$PATH

alias selen="java -jar ~/selenium-server-standalone.jar"

whoisusingport() { lsof -i tcp:$* }

start_docker() {
	cd /Applications/Docker/Docker\ Quickstart\ Terminal.app/Contents/Resources/Scripts
	bash 'start.sh'
}

# Local customisation...
local_file=$HOME/.local_profile
if [ -f "$local_file" ]
then
    source $local_file
fi
