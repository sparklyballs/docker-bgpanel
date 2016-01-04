#!/bin/bash

[[ ! -d /config/www/bgpanel/.git ]] && git clone https://github.com/warhawk3407/bgpanel /config/www/bgpanel

cd /config/www/bgpanel
git pull
chown -R abc:abc /config

