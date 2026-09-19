#!/bin/sh
# inject JELLYFIN_SERVER_URL into config.json at container start so it never gets baked into the image
set -e

if [ -n "$JELLYFIN_SERVER_URL" ]; then
    config=/usr/share/nginx/html/config.json
    tmp=$(mktemp)
    jq --arg url "$JELLYFIN_SERVER_URL" '.servers = [$url]' "$config" > "$tmp"
    cat "$tmp" > "$config"
    rm -f "$tmp"
fi
