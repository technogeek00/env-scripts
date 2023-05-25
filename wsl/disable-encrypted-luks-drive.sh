#!/bin/bash

# check script is running as root...
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# grab device name from command line, confirm it was actually given
DEVICE=$1

if [ -z $DEVICE ]; then
    echo "Must provide physical device name to open"
    exit
fi

# unmount has to be manually done for now...


# disable the volume groups, will fail if mounted
vgchange -an

# close the drive
cryptsetup luksClose $DEVICE