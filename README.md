# Generate GPG Keys with offline root server

Setup for secure offline CA: [Offline Server Setup](Offline_Server_Setup.md)   
Setup Yubikey for distribution: [Setup Yubikey](Setup_Yubikey.md)   


## Reset Yubikey (optional - for redistribution)

* Delete OTP config for slot 1 & 2  
* Reset PIV data  PIN: 123456  PUK: 12345678  
* Reset OATH data  
* Reset OpenPGP PIN: 123456  Admin Pin: 12345678  

```
> ykman otp delete 1 		
> ykman otp delete 2		
> ykman piv reset		 
> ykman oath reset		
> ykman openpgp reset	
```

## Setup new GPG Keys for <user@domain.com>

1. Start offline GPGRoot CA server (Debian v9)  
2. Ensure network adapter is disabled  
3. Ensure disk arbitrator is running (activated checkbox, mode: blocks mounts)

## Insert Encrypted USB
1. Insert primary USB [Unlock + PIN + Unlock] then insert into USB port    
2. Insert backup USB after primary is mounted [Unlock + PIN + Unlock] then insert into USB port

```
> ~/scripts/primary_mount
> ~/scripts/backup_mount
```

## Setup Yubikey
1. Insert new Yubikey and check Yubico.com in VMWare USB setting (not shared usb)  
2. Validate initial default pin works  
3. Change PIN|PUK retries to 5 [default 3]

```
> ykinfo -a (record serial for user in ‘User Yubi’
> yubico-piv-tool -a verify-pin  [verify pin first, default 123456]
> yubico-piv-tool -a verify -a pin-retries --puk-retries=5 --pin-retries=5
```

## Setup GPGHOME
Edit gpghome-username.sh and replace ‘user’ with ‘username’

```
> cd ~/scripts
> cp gpghome-user.sh gpghome-username.sh
> vim gpghome-username.sh
> . ./gpghome-username.sh
> echo $GNUPGHOME (make sure path looks right)
```


## Initialize GPGHOME directory
1. Create GPGHOME on primary USB  
2. Copy hardened gpg.conf from template folder  
3. Run Random Generator: [passphrase for master write down on paper and **/media/usb/info.txt** file]

```
> ~/scripts/00_gpg_initialize.sh
> gpg --gen-random -a 0 24 
```

## Generate GPG Master Key

```
> gpg --full-generate-key   [to get 4096 key length option]
```
**Prompts:** 
 
* pick: **4** RSA (sign only)  
* keysize: **4096**  
* valid for: **0**  [does not expire]  
* Is this correct? (y/N) **y**  
* real name: **Firstname Lastname**  
* email address: **flastname@domain.com**  
* Comment: **enter**  
* Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? **O**  
* Passphrase: **enter gpg random string**  

## Create revocation certificate

```
> export GPGKEY=6DEABF369
> ~/scripts/01_gpg_revocation.sh
```
**Prompts:**  

* Create a revocation certificate for this key? (y/N) **y**  
* Your decision? **1** (key has been compromised)  
* Enter an optional description; end it with an empty line:  
**Created during key creation, emergency use only.**  
* Is this okay? (y/N) **y**


## Create backup of master key

```
> ~/scripts/02_gpg_master_backup.sh
```


## Create subkeys [Sign, Encrypt, Authenticate]
Repeat this step for each Yubikey or multiple subkeys for different devices.  
Tip: Make each set of subkeys 1 yr apart (ie. 10y and 11y).  
Create all subkeys (multiple sets) before moving to Yubikey (keytocard).

```
> ~/scripts/03_gpg_create_subkeys.sh
```
**Prompts:**  

* gpg> **addkey**  
* Your selection? **4**  (RSA sign only)  
* What keysize do you want? (3072) **4096**  
* Key is valid for? (0) **10y**  
* Is this correct? (y/N) **y**  
* Really create? (y/N) **y**  

---
**Prompts:**  

* gpg> **addkey**  
* Your selection? **6** (RSA encrypt only)  
* What keysize do you want? (3072) **4096**  
* Key is valid for? (0) **10y**  
* Is this correct? (y/N) **y**  
* Really create? (y/N) **y**  

---
**Prompts:**  

* gpg> **addkey**  
* Your selection? **8** (RSA set your own capabilities)
* Your selection? **s** (remove sign)
* Your selection? **e** (remove encrypt)
* Your selection? **a** (add authenticate)
* Your selection? **q** (finished)
* What keysize do you want? (3072) **4096**  
* Key is valid for? (0) **10y**  
* Is this correct? (y/N) **y**  
* Really create? (y/N) **y**  

---
**Prompts:**  

* gpg> **save**  



## Export subkeys for backup
Note in the output of --list-secret-keys the keywords sec and ssb which means the main key and the subkeys are available. If the secret keyring contained only stubs, it would be sec> and sec#.

```
> gpg --list-keys
> gpg --list-secret-keys
> ~/scripts/04_gpg_subkeys_backup.sh
```

## Configure machine for smartcards

```
> gpg-agent --daemon
```

## Move subkeys to YubiKey
Moving subkeys to a Yubikey is a destructive operation, so make sure you took backups of the subkeys as above. After this step, your GnuPG keyring will contain stubs for the subkeys.

```
> ~/scripts/05_move_subkeys_yubikey.sh
```

**Prompts:**  

* gpg> **toggle**   
* gpg> **key 1** (first key ssb*)  
* gpg> **keytocard**  
* Your selection? **1** (signature)
* Admin PIN: **12345678**
* Repeat Admin PIN: **12345678**
* gpg> **key 1** (first key ssb deselected)
* gpg> **key 2** (second key ssb*)
* gpg> **keytocard** 
* Your selection? **2** (encryption)
* gpg> **key 2** (second key ssb deselected)
* gpg> **key 3** (third key ssb*)
* gpg> **keytocard** 
* Your selection? **3** (authentication)
* gpg> **save** 


## Export subkeys for backup

```
> gpg --list-secret-keys
> ~/scripts/06_gpg_stubs_backup.sh
```


## Backup Secure USB #1 to #2
If copy already exists, then rename with backup date extension
ie: > mv gpg-backup gpg-backup.20180818

```
> ~/scripts/08_gpg_backup_usb.sh
```

## Copy stubs to transfer USB

```
> xfer_2_mount.sh (san disk dual usb)
> ~/scripts/09_gpg_xfer_usb.sh
```

## Remove Encrypted USB

```
> ~/scripts/all_unmount
> sudo shutdown -h now
```
1. Remove all USB drives and Yubikey  
2. After VM is shutdown quit VMWare Fusion


## Save SSH Yubikey public key on Mac
1. Record serial number for asset tracking
2. Generate public ssh key (with Yubikey inserted) 

```
> cd ~/Documents/keys
> ykinfo -a (Note serial number to add append into text file)
> vim yubikeys.txt
> mkdir username
> cd username
> ssh-add -L | grep cardno > username_yubi_serial.pub
```

## Setup to require touch on Yubikey on MAC
**ykman set-touch aut on** does not seem to work with Yubikey 5

```
> ykman otp delete 1  (stop otp from touch)

# Yubikey 4
> ykman openpgp set-touch aut on
> ykman openpgp set-touch enc on
> ykman openpgp set-touch sig on 

- or -

# Yubikey 4/5
> ykman config usb --autoeject-timeout 180
```

