#!/bin/bash

function show_help {
  pwd
  printf "Use to customize the YunoHost app installation.\n \
          \t-a|--app-id: change app id in manifest.toml\n\
          \t-n|--name: change app name in manifest.toml\n\
          \t--desc-en: change English description in manifest.toml\n\
          \t--desc-fr: change French description in manifest.toml\n\
          \t-h|--help: this help menu\n"
}

function log {
  echo "==================== $1 ===================="
}

function change_app_id {
  local app_id=$1
  log "Change app ID to [${app_id}]"

  sed -ri 's/^(id = "docker_swarm"$)/id = \"'"${app_id}"'\"/' ./manifest.toml
}

function change_name {
  local name=$1
  log "Change name to [${name}]"

  sed -ri 's/^name\s*=\s*".*"\s*$/name = \"'"${name}"'\"/' ./manifest.toml
}

function change_desc_en {
  local desc_en=$1
  log "Change English description to [${desc_en}]"

  sed -ri 's/^description.en\s*=\s*".*"\s*$/description.en = \"'"${desc_en}"'\"/' ./manifest.toml
}

function change_desc_fr {
  local desc_fr=$1
  log "Change French description to [${desc_fr}]"

  sed -ri 's/^description.fr\s*=\s*".*"\s*$/description.fr = \"'"${desc_fr}"'\"/' ./manifest.toml
}

# Validate number of arguments
if [ $# -eq 0 ]
  then
    show_help
    exit 0
fi

# Parse arguments
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      -h|--help)
      show_help
      ;;
      -a|--app-id)
      shift
      change_app_id $1
      ;;
      -n|--name)
      shift
      change_name "$1"
      ;;
      --desc-en)
      shift
      change_desc_en "$1"
      ;;
      --desc-fr)
      shift
      change_desc_fr "$1"
      ;;
      *)
      show_help
      ;;
  esac
  shift
done

