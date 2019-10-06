#!/bin/bash
echo "Backup Master Key"
gpg -a --export-secret-keys $GPGKEY > $GPGBACKUP/gpg-masterkey.txt
cp -ar $GNUPGHOME $GNUPGHOME-backup-masterkey
mv $GNUPGHOME-backup-masterkey $GPGBACKUP

