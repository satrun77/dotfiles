#!/bin/bash

# Config


export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:$PATH
export PATH=~/.composer/vendor/bin/:$PATH


whoisusingport() { lsof -i tcp:$* }

searchphpmodule() { php -m | grep -e"$1" }


# Local customisation...
local_file=$HOME/.local_profile
if [ -f "$local_file" ]
then
    source $local_file
fi
