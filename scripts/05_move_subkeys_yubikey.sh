#!/bin/bash
echo "Move Private certificates of Sub-Keys to Yubikey"
gpg --edit-key $GPGKEY

