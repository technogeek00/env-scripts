#!/bin/bash

# Must be manually mounted in admin powershell into wsl2
# figure out the drive name and drop in the second command
# GET-CimInstance -query "SELECT * from Win32_DiskDrive"
# wsl --mount \\.\PHYSICALDRIVE3 --bare
# then you need to find the device name
# lsblk

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

# unlock the luks encryption
cryptsetup luksOpen /dev/$DEVICE $DEVICE

# scan for physical devices
vgscan

# force all found volumes to active
# note this is very aggressive, its assuming the environment does not have luks
# partitions and none are running, which is a fine assumption for base wsl2 for now...
# also assumes you've not tried to mount multiple, I'll have to tweak the script to do that
vgchange -ay

# force logical volume scan
lvscan

# trick for wsl2, force the creation of the mount points
dmsetup mknodes

# list the drives in /dev/mapper which will include the new nodes, just for convience
ll /dev/mapper/

# they will be the form: /dev/mapper/<vg_name>-<lv_name>, hopefully can automate that later
