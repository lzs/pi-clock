#!/bin/bash
# Screen

HOSTNAME=`hostname -s`

DISPLAY=:0.0 xwd -root -out $HOSTNAME.xwd
convert $HOSTNAME.xwd $HOSTNAME.png
