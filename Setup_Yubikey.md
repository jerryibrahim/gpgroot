# Setup Yubikey

## Setup Mac for Yubikey and GPG

```
> brew cask install gpg-suite
> brew install gnupg ykman ykpers libyubikey yubico-piv-tool ykneomgr
> which gpg2 (check if gpg2 is already installed, if not brew install gpg2)
```

## Import GPG keys
Insert Yubikey into usb port.  Copy contents to ~/Documents/keys

```
> mkdir ~/Documents/keys
> cd ~/Documents/keys

# copy your keys from usb drive to the new keys folder just created

> ykman list  (shows serial of Yubikey)
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
> sudo launchctl disable user/username/com.openssh.ssh-agent -w

- or -

> mdfind ssh-agent|grep plist
> launchctl unload -w /System/Library/LaunchAgents/com.openssh.ssh-agent.plist
> sudo launchctl disable system/com.openssh.ssh-agent
```

## Launch gpg-agent in ssh emulation mode at login
Append the following to ~/.gnupg/gpg-agent.conf  
> pinentry-program /usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac  
> enable-ssh-support  

```
> echo -e "\npinentry-program /usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac\nenable-ssh-support\n" >> ~/.gnupg/gpg-agent.conf
```

## Update terminal profiles
Update your .bash\_profile, .zshrc, .zprofile.  You will need to restart your shell or source your profile script.  
Append the following to ~/.bash\_profile (or other profile script)  
> gpg-agent --daemon  
> export SSH\_AUTH\_SOCK=\$HOME/.gnupg/S.gpg-agent.ssh


```
> echo -e "\n# Added for Yubikey support\ngpg-agent --daemon\nexport SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh\n" >> ~/.bash_profile

# exit terminal and restart terminal shell
```



## Copy public key to remote computer’s authorized_keys

1. Generate public key  
2. Create phantom private to enable ssh-copy-id to work

```
> cd ~/.ssh
> ssh-add -L > username_yubi.pub
> cp username_yubi.pub username_yubi
> chmod 600 username_yubi
```


**Optional:** copy to remote system’s ~/.ssh/authorized_keys

```
> ssh-copy-id -i username_yubi.pub user@hostname
```

## Setup Yubikey PIV PIN
 
1. Change Yubikey PIN: [default 123456, keep to 6 digits]  
2. Change Yubikey Admin PUK: [default 12345678, keep to 8 digits]  
3. Change PIN|PUK retries to 5

```
> yubico-piv-tool -a change-pin
> yubico-piv-tool -a change-puk
> yubico-piv-tool -a verify -a pin-retries --puk-retries=5 --pin-retries=5
```

## Setup Yubikey GPG PIN

```
>  gpg --card-edit
```
**Prompts:**  

* gpg/card> **admin**
* gpg/card> **passwd**  
* Your selection? **3** [change Admin PIN, default 12345678, recommend same as PUK PIN]  
* Your selection? **1** [change PIN, default 123456, recommend same as PIV PIN]  
* Your selection? **q** [quit]  
* gpg/card> **name**  
* Cardholder's surname: **Lastname**  
* Cardholder's given name: **Firstname**  
* gpg/card> **quit** [enter admin PIN when prompted]


## Setup Yubikey to auto eject after 3 min

```
> ykman config usb --autoeject-timeout 180
```

## Setup GIT for GPG signing
1. Login into Github, Gitlab, Bitbucket and upload GPG public key **publickey.txt**  
2. Use last 16 chars of signature key and configure git  

```
> gpg --list-secret-keys --keyid-format LONG  # Capture 16 chars after rsa4096/ of signature key
> git config --global user.signingkey <16 chars>
> git config --global commit.gpgsign true

> git log --show-signature  # To verify git commit has signature
```
