#!/bin/bash
echo "Backup GPG stubs to XFER USB Drive"
sudo mkdir $GPGXFER
sudo cp $GPGBACKUP/masterstubs.txt $GPGXFER
sudo cp $GPGBACKUP/subkeysstubs.txt $GPGXFER
sudo cp $GPGBACKUP/publickey.txt $GPGXFER

