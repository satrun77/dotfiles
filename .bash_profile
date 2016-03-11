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
        return;
    fi
    cd $MYWORKSPACE && vagrant ssh
}

workspace() {
    if [ "$1" = "help" ]
    then
        message ${YELLOW} "Execute vagrant up/down/distory/..."
        return;
    fi
    cd $MYWORKSPACE
    vagrant ${1-up}
    osascript -e 'display notification "Workspace $1 complete!" with title "Workspace"'
}

updatespace() {
    if [ "$1" = "help" ]
    then
        message ${YELLOW} "Execute vagrant provision"
        return;
    fi
    cd $MYWORKSPACE
    vagrant provision
    osascript -e 'display notification "Workspace provision complete!" with title "Workspace"'
}

changespace() {
    if [ "$1" = "help" ]
    then
        message ${YELLOW} "Open to edit workspace environment config"
        return;
    fi
    vim $MYWORKSPACE/config/environment.yaml
}

createplanet() {
    if [ "$1" = "help" ]
    then
        message ${YELLOW} "Create a new planet (site) [name] [title]"
        return;
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
        return;
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
        return;
    fi

    for var in "$@"
    do
        message ${CYAN} "Fixing: $var"
        message ${YELLOW} "------------------------------"
        php-cs-fixer fix $var --fixers=psr0,encoding,short_tag,braces,class_definition,elseif,eof_ending,function_call_space,function_declaration,indentation,line_after_namespace,linefeed,lowercase_constants,lowercase_keywords,method_argument_space,multiple_use,no_trailing_whitespace_in_comment,parenthesis,php_closing_tag,single_line_after_imports,switch_case_semicolon_to_colon,switch_case_space,trailing_spaces,visibility,array_element_no_space_before_comma,array_element_white_space_after_comma,blankline_after_open_tag,duplicate_semicolon,extra_empty_lines,function_typehint_space,hash_to_slash_comment,heredoc_to_nowdoc,include,join_function,lowercase_cast,method_argument_default_value,multiline_array_trailing_comma,namespace_no_leading_whitespace,native_function_casing,new_with_braces,no_blank_lines_after_class_opening,no_empty_lines_after_phpdocs,object_operator,operators_spaces,phpdoc_indent,phpdoc_inline_tag,phpdoc_no_access,phpdoc_params,phpdoc_scalar,phpdoc_separation,phpdoc_short_description,phpdoc_to_comment,phpdoc_trim,phpdoc_type_to_var,phpdoc_types,print_to_echo,remove_leading_slash_use,remove_lines_between_uses,return,self_accessor,short_scalar_cast,single_array_no_trailing_comma,single_blank_line_before_namespace,single_quote,spaces_after_semicolon,spaces_before_semicolon,spaces_cast,standardize_not_equal,ternary_spaces,trim_array_spaces,whitespacy_lines,align_double_arrow,align_equals,short_array_syntax --verbose
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
