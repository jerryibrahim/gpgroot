#!/bin/bash

echo "GPG Quick Create"
gpg --quick-gen-key "$1" rsa4096 cert none

