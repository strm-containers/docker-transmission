#!/bin/bash

echo '[+] Configuration files not found, generating settings.json'
if [ -z "$TRANSMISSION_PASSWORD" ]
then
    echo '[+] You should set a password, set it in TRANSMISSION_PASSWORD variable'
    exit -1
fi

if [ -z "$TRANSMISSION_DOWNLOAD_LIMIT" ]
then
    TRANSMISSION_DOWNLOAD_LIMIT='1024'
fi

if [ -z "$TRANSMISSION_DOWNLOAD_QUEUE" ]
then
    TRANSMISSION_DOWNLOAD_QUEUE='20'
fi

cat > /etc/transmission-daemon/settings.json << EOF
{
    "alt-speed-down": 50,
    "alt-speed-enabled": false,
    "alt-speed-time-begin": 540,
    "alt-speed-time-day": 127,
    "alt-speed-time-enabled": false,
    "alt-speed-time-end": 1020,
    "alt-speed-up": 50,
    "bind-address-ipv4": "0.0.0.0",
    "bind-address-ipv6": "::",
    "blocklist-enabled": false,
    "blocklist-url": "http://www.example.com/blocklist",
    "cache-size-mb": 64,
    "dht-enabled": true,
    "download-dir": "/downloads",
    "download-queue-enabled": true,
    "download-queue-size": $TRANSMISSION_DOWNLOAD_QUEUE,
    "encryption": 1,
    "idle-seeding-limit": 30,
    "idle-seeding-limit-enabled": false,
    "incomplete-dir": "/incomplete",
    "incomplete-dir-enabled": true,
    "lpd-enabled": false,
    "message-level": 2,
    "peer-congestion-algorithm": "",
    "peer-id-ttl-hours": 6,
    "peer-limit-global": 2000,
    "peer-limit-per-torrent": 500,
    "peer-port": 6669,
    "peer-port-random-high": 65535,
    "peer-port-random-low": 49152,
    "peer-port-random-on-start": false,
    "peer-socket-tos": "default",
    "pex-enabled": true,
    "port-forwarding-enabled": false,
    "preallocation": 1,
    "prefetch-enabled": 1,
    "queue-stalled-enabled": true,
    "queue-stalled-minutes": 10,
    "ratio-limit": 1,
    "ratio-limit-enabled": true,
    "rename-partial-files": true,
    "rpc-authentication-required": true,
    "rpc-bind-address": "0.0.0.0",
    "rpc-enabled": true,
    "rpc-password": "$TRANSMISSION_PASSWORD",
    "rpc-port": 9091,
    "rpc-url": "/transmission/",
    "rpc-username": "transmission",
    "rpc-whitelist": "127.0.0.1",
    "rpc-whitelist-enabled": false,
    "scrape-paused-torrents-enabled": true,
    "script-torrent-done-enabled": true,
    "script-torrent-done-filename": "/trigger.sh",
    "seed-queue-enabled": true,
    "seed-queue-size": 1,
    "speed-limit-down": $TRANSMISSION_DOWNLOAD_LIMIT,
    "speed-limit-down-enabled": true,
    "speed-limit-up": 5,
    "speed-limit-up-enabled": true,
    "start-added-torrents": true,
    "trash-original-torrent-files": false,
    "umask": 18,
    "upload-slots-per-torrent": 1,
    "utp-enabled": true
}
EOF

while true
do
    /usr/bin/transmission-daemon -f --no-portmap --config-dir /etc/transmission-daemon --log-info 
    echo '[-] Transmission exited, waiting before a restart'
    sleep 30
done
