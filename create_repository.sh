#!/bin/bash -u

if [[ -f "$HOME/.gprc_cache" ]]; then
  login_name=$(cat "$HOME/.gprc_cache" | cut -d ':' -f 1)
  api_token=$(cat "$HOME/.gprc_cache" | cut -d ':' -f 2)
else
  echo -n "your github login name? :"
  read login_name
  echo -n "your api token? (you can create api token from https://github.com/settings/tokens/new ) :"
  read api_token

  echo "${login_name}:${api_token}" >"$HOME/.gprc_cache"
fi

repo_name=''
if [[ $# -eq 1 ]]; then
  repo_name="${1}"
else
  echo -n "repository name? [${PWD##*/}] :"
  read repo_name

  if [[ -z ${repo_name} ]]; then
    repo_name=${PWD##*/}
  fi
fi

curl \
  -u "$login_name:$api_token" https://api.github.com/user/repos \
  -d '{"name":"'$repo_name'"}' \
  | php -r '$json = (array) json_decode(file_get_contents("php://stdin")); echo $json["ssh_url"] . "\n";' \
  ;
