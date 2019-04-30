#!/bin/bash

# SFR Wifi FON reconnection

# Variables
login="login" # sfr wifi fon login
password="password" # sfr wifi fon password
vpn_id="vpnid" # vpn connection id (optional)
wifi_id="SFR WiFi FON" # sfr wifi fon network id

# Optional : disconnect from VPN
#nmcli con down id "$vpn_id"

# Optional : disconnect from WiFi and reconnect
#nmcli con down id "$wifi_id"
#nmcli con up id "$wifi_id"

# Get redirect url
redirect_url=$(curl -Ls -o /dev/null -w %{url_effective} detectportal.firefox.com)

# Get redirect url parameters
query_string=${redirect_url##*\?}
for p in ${query_string//&/ };do kvp=( ${p/=/ } ); k=${kvp[0]};v=${kvp[1]};eval $k=$v;done

# Send request to nb4_crypt.php
nb4_url="https://hotspot.wifi.sfr.fr/nb4_crypt.php"
post_data="choix=neuf&username=$login&password=$password&conditions=on&save=on&challenge=$challenge&username2=$login&accessType=neuf&lang=fr&mode=$mode&userurl=detectportal.firefox.com&uamip=$uamip&uamport=$uamport&channel=$channel&mac=$mac|$nasid&connexion=CONNEXION"
curl -s -d $post_data -X POST $nb4_url -o post_results
newloc=`grep location post_results | awk 'BEGIN { FS="\"" } { print $2 }'`
curl -s $newloc -o newloc

# Optional : reconnect to VPN
#nmcli con up id "$vpn_id"
