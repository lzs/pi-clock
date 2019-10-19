#!/bin/sh

yes=0

do_help() {
    command=`basename $0`
    cat <<EOM
Usage $basename [options]

Installer to put stuffs in the right places.
EOM
}

while getopts "h?y" opt; do
    case "$opt" in
    h|\?)
        do_help
        exit 0
        ;;
    y)
        yes=1
        ;;
    esac
done

cp bash_profile ~/.bash_profile

mkdir ~/pi-clock
cp -r index.html config.json.dist js script.js style.css ~/pi-clock

mkdir -p ~/.config/openbox
cp autostart ~/.config/openbox/

# Install crontab for checking health
(crontab -l 2>/dev/null | grep -v "bin/checkhealth.sh"; echo "* * * * * bin/checkhealth.sh") | crontab -
