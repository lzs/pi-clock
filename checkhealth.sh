#!/bin/sh

GATEWAY=`ip route show | grep default | cut -d\  -f3`

if [ "x$GATEWAY" = "x" ] ; then
    logger "HEALTHCHECK: No gateway found."
    echo `date` >> /tmp/checkhealth
elif ping -c3 "$GATEWAY" > /dev/null 2>&1; then
    cp /dev/null /tmp/checkhealth
else
    echo `date` >> /run/checkhealth
    if [ `cat /tmp/checkhealth | wc -l` -gt 3 ]; then
        logger "HEALTHCHECK: Network has been unreachable. Rebooting."
        sudo reboot
    else
        logger "HEALTHCHECK: Ping to $GATEWAY failed."
    fi
fi
