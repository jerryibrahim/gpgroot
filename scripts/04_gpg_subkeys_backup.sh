#!/bin/bash
echo "Backup Subkeys"
gpg -a --export-secret-keys $GPGKEY > $GPGBACKUP/gpg-mastersubkeys.txt
gpg -a --export-secret-subkeys $GPGKEY > $GPGBACKUP/gpg-subkeys.txt
cp -ar $GNUPGHOME $GNUPGHOME-backup-mastersubkeys
mv $GNUPGHOME-backup-mastersubkeys $GPGBACKUP

