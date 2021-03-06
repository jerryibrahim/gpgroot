#!/bin/bash
echo "Backup to USB Drive 2"
mkdir $GNUPGHOME2
mkdir $GPGBACKUP2
sudo cp -r --copy-contents --preserve $GNUPGHOME/* $GNUPGHOME2
sudo cp -r --copy-contents --preserve $GPGBACKUP/* $GPGBACKUP2
__DateTime=`date +"%Y%m%d_%H%M"`
sudo cp /media/usb/info.txt /media/usb/info.txt.${__DateTime}
sudo cp /media/usb/info.txt /media/usb_backup/info.txt.${__DateTime}
sudo cp /media/usb/info.txt /media/usb_backup/info.txt

