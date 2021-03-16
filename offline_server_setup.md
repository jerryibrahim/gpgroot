# Setup Offline Server
Using Debian v10 (buster)  
Using VMWare Fusion 

## Setup minimal server with user as the username

### Install some utilities
  
```
> su root (so you can install sudo)
> apt install sudo
> /usr/sbin/usermod -aG sudo user
> exit
> exit (logout / login again as user)
```

### Now sudo works install rest of tools

```
> sudo apt install exfat-fuse
> sudo apt install gnupg2
> sudo apt install scdaemon
> sudo apt install yubikey-personalization
> sudo apt install yubikey-manager
> sudo apt install pcscd
> sudo apt install pcsc-tools
> sudo apt install software-properties-common
> sudo apt install libyubikey-dev 
> sudo apt install pkg-config 
> sudo apt install libusb-1.0-0-dev 
> sudo apt install libjson-c-dev
> sudo apt install vim
> sudo apt install git
> sudo apt install gpm
> sudo apt install man-db


> sudo apt install dirmngr
> sudo apt install cryptsetup
> sudo apt install secure-delete
> sudo apt install hopenpgp-tools
> sudo apt install rng-tools

> sudo apt install --reinstall python3-pkg-resources
```

### Install helper scripts/template

```
> cd ~
> git clone https://github.com/jerryibrahim/gpgroot
> cp -r ~/gpgroot/scripts ~/scripts
> cp -r ~/gpgroot/template ~/template
> rm -rf gpgroot
```

### Validate Encrypted USB stick is visible:

```
> lsusb  (list usb devices)
> lsblk  (find where the drive is)
```

### Modify USB UUID for primary, backup, and xfer USB sticks 

```
> vim ~/scripts/primary_mount.sh
> vim ~/scripts/backup_mount.sh
> vim ~/scripts/xfer_mount.sh (uses XFER label)
> vim ~/scripts/xfer_2_mount.sh
```

### Update $PATH to include /sbin and ~/scripts 

```
> echo -e "\nexport PATH=\"$PATH:/sbin:~/scripts\"\n" >> .bashrc
```


## For VMWare:  
1. Remove network adapter after all utilities are installed

2. Update VMWare to allow usb passthrough for Yubikey  
<https://support.yubico.com/support/solutions/articles/15000008891-troubleshooting-vmware-workstation-device-passthrough>

3. **Updating the Virtual Machine's Configuration**  

	* Shut down the virtual machine  
	* Locate the VM's .vmx configuration file. For more information, see VMWare's KB article on this. Open the configuration file with a text editor.
	* Add the two lines below to the file and save it.
		* **usb.generic.allowHID = "TRUE"**
		* **usb.generic.allowLastHID = "TRUE"**
	
	* At this point, a non-shared YubiKey or Security Key should be available for passthrough. If not, you may need to manually specify the USB vendor ID and product ID in the configuration file as well. The example below is for a YubiKey 4.
	
		* **usb.quirks.device0 = "0x1050:0x0407 allow"**

4. **Install vmware tools:**  
<https://docs.vmware.com/en/VMware-vSphere/5.5/com.vmware.vmtools.install.doc/GUID-08BB9465-D40A-4E16-9E15-8C016CC8166F.html>

