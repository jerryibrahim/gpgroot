# Setup Yubikey

## Setup Mac for Yubikey and GPG

```
> brew cask install gpg-suite
> brew install gnupg ykman ykpers libyubikey yubico-piv-tool ykneomgr
> which gp2 (check if gpg2 is already installed, if not brew install gpg2)

> ykman list  (shows serial of Yubikey)
> ykneomgr -m (should be 06)
```

## Import GPG keys
Insert Yubikey into usb port.  

```
> gpg --import masterstubs.txt  [enter passphrase]
> gpg --import subkeysstubs.txt
> gpg --import publickey.txt

> gpg --edit-key user@domain.com
```
**Prompts:**

* gpg> **trust**  
* Your decision?  **5** (I trus ultimately)  
* Do you really want to set this key to ultimate trust? (y/N) **y**
* gpg> **quit**


Should see Yubikey info and gpg keys

```
> gpg --card-status 
```

## Disable ssh-agent at login

```
> sudo launchctl disable user/jibrahim/com.openssh.ssh-agent -w
```

## Launch gpg-agent in ssh emulation mode at login
Modify/create a gpg-agent.conf file in ~/.gnupg:

```
> cat ~/.gnupg/gpg-agent.conf
pinentry-program /usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac
enable-ssh-support
default-cache-ttl 600
max-cache-ttl 7200
```

Launch gpg-agent in your .zshrc or .zprofile and export the SSH_AUTH_SOCK env variable to # point to the gpg-agent socket. 

```
> cat ~/.bash_profile
gpg-agent --daemon
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
```


Require touch capabilities on the Yubikey for the OpenPGP keys
Use ykman to enable "aut" touch behavior. For instance, to enable touch for the "aut" key 
which is the one that makes most sense for SSH:

```
> ykman otp delete 1  (stop otp from touch)
> ykman openpgp set-touch aut on
> ykman openpgp set-touch enc on
> ykman openpgp set-touch sig on
```

## Copy public key to remote computer’s authorized_keys

Generate public key  
Create phantom private to enable ssh-copy-id to work

```
> cd ~/.ssh
> ssh-add -L | grep cardno > username_yubi.pub
> cp username_yubi.pub username_yubi
```


Copy to remote system’s ~/.ssh/authorized_keys

```
> ssh-copy-id -i username_yubi.pub user@hostname
```

## Setup Yubikey PIV PIN
------------------------------
Change Yubikey Admin PIN | PUK:  
Change PIN|PUK retries to 5 [default 3]

```
> yubico-piv-tool -a verify-pin  [verify pin first, default 123456]
> yubico-piv-tool -a change-pin  [change pin, keep to 6 digits]
> yubico-piv-tool -a change-puk  [change puk, default 12345678, keep to 8 digits]
> yubico-piv-tool -a verify -a pin-retries --puk-retries=5 --pin-retries=5
```

## Setup Yubikey GPG PIN

```
>  gpg --card-edit
```
**Prompts:**  

* gpg/card> **admin**
* gpg/card> **passwd**  
* Your selection? **3** [change Admin PIN, default 12345678]  
* Your selection? **1** [change PIN, default 123456]  
* Your selection? **q** [quit]  
* gpg/card> **name**  
* Cardholder's surname: **LASTNAME**  
* Cardholder's given name: **FIRSTNAME**  
* gpg/card> **quit** [enter admin PIN when prompted]

