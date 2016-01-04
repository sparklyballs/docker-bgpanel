#!/bin/bash

[[ ! -d /config/www/bgpanel/.git ]] && git clone https://github.com/warhawk3407/bgpanel /config/www/bgpanel

cd /config/www/bgpanel
git pull
chown -R abc:abc /config

if [ ! -d "/config/log/myqsl" ]; then
mkdir -p /config/log/mysql
fi


if [ ! -d "$DATADIR" ]; then
mkdir -p "$DATADIR"
fi

if [ ! -d "/var/run/mysqld" ]; then
mkdir -p /var/run/mysqld
chmod -R 777 /var/run/mysqld
fi

