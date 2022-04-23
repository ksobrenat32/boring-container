#!/usr/bin/env bash
set -euo pipefail

if [[ -z "$(ls -A /dns)" ]]; then
    echo 'Generating config'
    mkdir -p /dns/{blocky,unbound}
    mv /opt/unbound.conf /dns/unbound/unbound.conf
fi

echo 'Downloading updated root hints ...'
curl -fsSL -o /dns/unbound/root.hints https://www.internic.net/domain/named.cache
echo 'Generating a trust-anchor ...'
/usr/sbin/unbound-anchor &
sleep 5
echo 'Testing unbound config ...'
/usr/sbin/unbound-checkconf
echo 'Starting unbound'
/usr/sbin/unbound

if [[ -z "$(ls -A /dns/blocky)" ]]; then
    echo 'No blocky configuration detected, downloading mine ...'
    curl -fsSL -o /dns/blocky/config.yml https://raw.githubusercontent.com/ksobrenat32/notes/main/dns/blocky/config.yml
else
    echo 'Detected blocky config.yml'
fi

echo 'Starting blocky, DNS ad blocker'
/usr/bin/blocky --config /dns/blocky/config.yml
