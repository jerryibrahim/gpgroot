#!/bin/bash
echo "Backup to USB Drive 2"
mkdir $GNUPGHOME2
mkdir $GPGBACKUP2
cp -r --copy-contents --preserve -v $GNUPGHOME/* $GNUPGHOME2
cp -r --copy-contents --preserve -v $GPGBACKUP/* $GPGBACKUP2

