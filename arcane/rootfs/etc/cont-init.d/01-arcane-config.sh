#!/usr/bin/with-contenv bashio
set -e

mkdir -p /data /tmp/nginx/client_temp /tmp/nginx/proxy_temp
chmod 700 /data

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

export APP_URL="http://127.0.0.1:3552"
export ANALYTICS_DISABLED=true
export PROJECTS_DIRECTORY=/data/projects

mkdir -p "$PROJECTS_DIRECTORY"

# Arcane runs with UID/GID 65532; give it access to persistent data.
chown -R 65532:65532 /data
chmod 700 /data
chmod 700 /data/projects
chmod 600 /data/.encryption_key
