#!/bin/bash
echo "Backup Stubs"
gpg -a --export-secret-keys $GPGKEY > $GPGBACKUP/masterstubs.txt
gpg -a --export-secret-subkeys $GPGKEY > $GPGBACKUP/subkeysstubs.txt
gpg -a --export $GPGKEY > $GPGBACKUP/publickey.txt
sudo cp -ar $GNUPGHOME $GNUPGHOME-backup-masterstubs
sudo mv $GNUPGHOME-backup-masterstubs $GPGBACKUP

