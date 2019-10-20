#!/bin/bash

echo "Change Yubikey retries to 5"
yubico-piv-tool -a verify -a pin-retries --puk-retries=5 --pin-retries=5
