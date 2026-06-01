#!/usr/bin/env bash

vpn_active=""
#vpn_active=""
vpn_inactive=""

while true; do
    if (nordvpn status | grep -o Connected) &>/dev/null; then
            #echo "$vpn_active  OK" ; sleep 25
            echo "$vpn_active VPN OK" ; sleep 25
    else
        #echo "$vpn_inactive  VPN Offline" ; sleep 5
        echo "$vpn_inactive VPN Offline" ; sleep 5
    fi
done
