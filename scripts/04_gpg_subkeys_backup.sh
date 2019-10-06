#!/bin/bash
echo "Backup Subkeys"
gpg -a --export-secret-keys $GPGKEY > $GPGBACKUP/gpg-mastersubkeys.txt
gpg -a --export-secret-subkeys $GPGKEY > $GPGBACKUP/gpg-subkeys.txt
sudo cp -ar $GNUPGHOME $GNUPGHOME-backup-mastersubkeys
sudo mv $GNUPGHOME-backup-mastersubkeys $GPGBACKUP

