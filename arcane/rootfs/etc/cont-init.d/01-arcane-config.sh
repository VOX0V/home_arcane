#!/usr/bin/with-contenv bashio
set -e

mkdir -p /data /tmp/nginx/client_temp /tmp/nginx/proxy_temp
chmod 700 /data

# Preserve a generated key in persistent add-on storage if the user did not
# supply one in the add-on options. Never regenerate it after first startup.
KEY="$(bashio::config 'encryption_key')"
if [ -z "$KEY" ]; then
  if [ -s /data/.encryption_key ]; then
    KEY="$(cat /data/.encryption_key)"
  else
    KEY="$(openssl rand -hex 32)"
    printf '%s' "$KEY" > /data/.encryption_key
    chmod 600 /data/.encryption_key
  fi
fi
export ENCRYPTION_KEY="$KEY"

# The UI is exposed only through Supervisor ingress. Remote VM agents use
# the internal manager API on the add-on network; no host port is published.
export APP_URL="http://127.0.0.1:3552"
export ANALYTICS_DISABLED=true
export PROJECTS_DIRECTORY=/data/projects
mkdir -p "$PROJECTS_DIRECTORY"
