#!/bin/bash

echo "GPG Backup Revocation Certificate"

export GPGKEY=`gpg --list-keys --with-colons  | awk -F: '/fpr:/ {print $10}'`
echo "GPG FPR: $GPGKEY" 

cp $GNUPGHOME/openpgp-revocs.d/$GPGKEY.rev $GPGBACKUP/gpg-revocation-certificate.txt
