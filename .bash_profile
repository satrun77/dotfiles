#!/bin/bash


# Local customisation...
local_file=$HOME/.local_profile
if [ -f "$local_file" ]
then
    source $local_file
fi
