# Setup Yubikey from offline key generation

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
> default-cache-ttl-ssh 600  
> max-cache-ttl-ssh 7200  
> pinentry-program /usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac  
> enable-ssh-support  

```
> echo -e "\n# Added for Yubikey support\ndefault-cache-ttl-ssh 600\nmax-cache-ttl-ssh 7200\npinentry-program /usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac\nenable-ssh-support\n" >> ~/.gnupg/gpg-agent.conf
```

## Update terminal profiles
Update your .bash\_profile, .zshrc, .zprofile.  You will need to restart your shell or source your profile script.  
Append the following to ~/.bash\_profile (or other profile script)  
> export LANG=en  
> export LC_ALL=en_US.UTF-8  
> export GPG_TTY=$(tty)  
> export SSH\_AUTH\_SOCK=\$HOME/.gnupg/S.gpg-agent.ssh  
> gpg-agent --daemon  
> alias gpgreset='gpg-connect-agent killagent /bye; gpg-connect-agent updatestartuptty /bye; gpg-connect-agent /bye'  

```
# bash profile
> echo -e "\n# Added for Yubikey support\nexport LANG=en\nexport LC_ALL=en_US.UTF-8\nexport GPG_TTY=$(tty)\nexport SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh\ngpg-agent --daemon\n\nalias gpgreset='gpg-connect-agent killagent /bye; gpg-connect-agent updatestartuptty /bye; gpg-connect-agent /bye'\n" >> ~/.bash_profile

# zsh profile
> echo -e "\n# Added for Yubikey support\nexport LANG=en\nexport LC_ALL=en_US.UTF-8\nexport GPG_TTY=$(tty)\nexport SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh\ngpg-agent --daemon\n\nalias gpgreset='gpg-connect-agent killagent /bye; gpg-connect-agent updatestartuptty /bye; gpg-connect-agent /bye'\n" >> ~/.zprofile

# exit terminal and restart terminal shell
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


## Setup Yubikey to auto eject after 5 min

```
> ykman config usb --autoeject-timeout 300
```


## Yubikey Usage Info
[Yubikey usage](yubikey_usage.md) 