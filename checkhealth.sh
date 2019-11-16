#!/bin/sh

# Checks network reachability and tries to reboot if network has been broken
# for some time.

GATEWAY=`ip route show | grep default | cut -d\  -f3`

if [ "x$GATEWAY" = "x" ] ; then
    logger "HEALTHCHECK: No gateway found."
    echo `date` >> /tmp/checkhealth
elif ping -c3 "$GATEWAY" > /dev/null 2>&1; then
    # Ping is ok
    if [ `cat /tmp/checkhealth | wc -l` -gt 0 ]; then
        # Network recovered after unreachable, we'll clear counter and refresh browser
        cp /dev/null /tmp/checkhealth
        xdotool key ctrl+r
    fi
else
    # Ping is NOT ok
    echo `date` >> /run/checkhealth
    if [ `cat /tmp/checkhealth | wc -l` -gt 3 ]; then
        # We've been unreachable for too long, let's try to reboot
        logger "HEALTHCHECK: Network has been unreachable. Rebooting."
        sudo reboot
    else
        # Otherwise just log the event
        logger "HEALTHCHECK: Ping to $GATEWAY failed."
    fi
fi
