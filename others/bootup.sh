#!/bin/sh

# SERVER=xxx

HOST=`hostname -s`
ETHMAC=`cat /sys/class/net/eth0/address`
WLANMAC=`cat /sys/class/net/wlan0/address`

ssh $SERVER bootup $HOST $ETHMAC $WLANMAC
