#!/bin/bash

_USB_UUID="5D87-C5AF" 
_USB_MOUNT="/media/usb"

echo " "
echo "Mounting SECURE PRIMARY USB"
echo "-------------------------------------------"

_USB_DEVICE=`sudo blkid | grep ${_USB_UUID} | awk '{print $1}' | sed 's/://'`

if [ ! -z $_USB_DEVICE ] ; then
	echo "Found: $_USB_UUID at $_USB_DEVICE"
	if [ ! -d $_USB_MOUNT ] ; then
		sudo mkdir $_USB_MOUNT 
	fi
	sudo mount $_USB_DEVICE $_USB_MOUNT
	echo "SECURE PRIMARY USB mounted: $_USB_MOUNT"
	echo "-------------------------------------------"
else
	echo "USB Device: $_USB_UUID" not found.  Mount Failed.	
fi

