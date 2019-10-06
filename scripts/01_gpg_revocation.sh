#!/bin/bash
echo "Backup GPG Revocation Certificate"
gpg --output $GPGBACKUP/gpg-revocation-certificate.txt --gen-revoke $GPGKEY

