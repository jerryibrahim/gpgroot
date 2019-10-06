#!/bin/bash
echo "Backup Master Key"
gpg -a --export-secret-keys $GPGKEY > $GPGBACKUP/gpg-masterkey.txt
sudo cp -ar $GNUPGHOME $GNUPGHOME-backup-masterkey
sudo mv $GNUPGHOME-backup-masterkey $GPGBACKUP

