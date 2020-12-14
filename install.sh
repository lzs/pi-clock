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

if test -f ~/.bash_profile; then
    if [ $yes -eq 0 ]; then
        read -p "Overwrite existing .bash_profile? " -n 1 PROMPT
        echo
        if [[ ! $PROMPT =~ ^[Yy]$ ]]; then
            echo Aborted.
            exit 1
        fi
    fi
fi

cp bash_profile ~/.bash_profile

if test -d ~/pi-clock; then
    if [ $yes -eq 0 ]; then
        read -p "Reuse existing ~/pi-clock directory? " -n 1 PROMPT
        echo
        if [[ ! $PROMPT =~ ^[Yy]$ ]]; then
            echo Aborted.
            exit 1
        fi
    fi
else
    mkdir ~/pi-clock
fi

cp -r index.html config.json.dist js script.js style.css fonts ~/pi-clock

if test -d ~/.config/openbox; then
    if [ $yes -eq 0 ]; then
        read -p "Reuse existing ~/.config/openbox directory? " -n 1 PROMPT
        echo
        if [[ ! $PROMPT =~ ^[Yy]$ ]]; then
            echo Aborted.
            exit 1
        fi
    fi
else
    mkdir -p ~/.config/openbox
fi

mkdir -p ~/.config/lxsession/LXDE-pi
cp autostart ~/.config/lxsession/LXDE-pi/autostart
chmod 755 ~/.config/lxsession/LXDE-pi/autostart

# Install unclutter to remove mouse pointer
sudo apt install -y unclutter

# Install crontab for checking health
(crontab -l 2>/dev/null | grep -v "bin/checkhealth.sh"; echo "* * * * * bin/checkhealth.sh") | crontab -

# Set SSH enabled
sudo raspi-config nonint do_ssh 0

# Set GUI autologin
sudo raspi-config nonint do_boot_behaviour B4

# Overscan if need
sudo raspi-config nonint do_overscan 1

# Set timezone
sudo raspi-config nonint do_change_timezone Asia/Singapore

# Disable setup wizard
sudo rm /etc/xdg/autostart/piwiz.desktop
