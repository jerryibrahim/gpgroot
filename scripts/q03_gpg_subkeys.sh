#!/bin/bash

echo "GPG Sub Keys"

gpg --quick-add-key $GPGKEY rsa4096 sign 10y
gpg --quick-add-key $GPGKEY rsa4096 encr 10y
gpg --quick-add-key $GPGKEY rsa4096 auth 10y
