#!/bin/bash

# Config

# Path

export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:$PATH
export PATH=~/.composer/vendor/bin/:$PATH

# Aliases

whoisusingport() { lsof -i tcp:$* }

searchphpmodule() { php -m | grep -e"$1" }

alias cat=bat
alias update_docker_sync=gem install docker-sync --user-install

ds_restart(){
    docker-sync clean && docker-sync start
}

gitdate() {
    GIT_COMMITTER_DATE="$1" git commit --amend

    git commit --amend --date="$1"
}

ds_debug() {

diff -q "$1" <(docker exec "$2" cat "/host_sync/$1")
echo "\n------------------------------"
diff -q "$1" <(docker exec "$2" cat "/app_sync/$1")

}

go_to_sleep() {
    pmset sleepnow
}

SPACESHIP_PROMPT_ORDER=(
  time        # Time stamps section (Disabled)
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  #hg            # Mercurial section (hg_branch  + hg_status)
  package     # Package version (Disabled)
  node          # Node.js section
  #ruby          # Ruby section
  #elixir        # Elixir section
  # xcode       # Xcode section (Disabled)
  swift         # Swift section
  #golang        # Go section
  php           # PHP section
  #rust          # Rust section
  #haskell       # Haskell Stack section
  # julia       # Julia section (Disabled)
  docker      # Docker section (Disabled)
  #aws           # Amazon Web Services section
  #venv          # virtualenv section
  #conda         # conda virtualenv section
  #pyenv         # Pyenv section
  #dotnet        # .NET section
  # ember       # Ember.js section (Disabled)
  #kubecontext   # Kubectl context section
  #terraform     # Terraform workspace section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  # vi_mode     # Vi-mode indicator (Disabled)
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true
#SPACESHIP_TIME_SHOW=true
SPACESHIP_DIR_SHOW=true
SPACESHIP_DIR_TRUNC=9
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_DIR_EXPAND_USER_PATH=true

# Local customisation...
local_file=$HOME/.local_profile
if [ -f "$local_file" ]
then
    source $local_file
fi
