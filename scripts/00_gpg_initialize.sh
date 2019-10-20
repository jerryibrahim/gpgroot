#!/bin/bash
echo "Initializing GPGHOME Directory"
mkdir $GNUPGHOME
mkdir $GPGBACKUP
sudo cp ~/template/gpg.conf $GNUPGHOME
cd $GNUPGHOME
pwd
ls -la
cd ~
sudo rngd -r /dev/urandom
gpg --gen-random -a 0 24
