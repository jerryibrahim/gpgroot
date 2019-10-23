# Generating Your GPG Key directly on Your YubiKey
Warning: Generating the GPG on the YubiKey ensures that malware can never steal your GPG private key, but it means that the key can not be backed up so if your YubiKey is lost or damaged the GPG key is irrecoverable.  [source](https://support.yubico.com/support/solutions/articles/15000006420-using-your-yubikey-with-openpgp) 



## Setup Mac for Yubikey and GPG

```
> brew cask install gpg-suite
> brew install gnupg ykman ykpers libyubikey yubico-piv-tool ykneomgr
> which gpg2 (check if gpg2 is already installed, if not brew install gpg2)
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


## Create GPG key in Yubikey

1. Insert the YubiKey into the USB port if it is not already plugged in.  
2. Open Command Prompt (Windows) or Terminal (macOS / Linux).  
3. Enter the GPG command: **gpg --card-edit**  
4. At the **gpg/card>** prompt, enter the command: **admin**  
5. Run: **key-attr**, select  **(1) RSA** and **4096** key size for Signature, Encryption, Authentication prompts  
6. Enter the command: **generate**  
7. When prompted, specify **YES** to make an off-card backup of your encryption key.  
Note: This is a shim backup of the private key, not a full backup, and cannot be used to restore to a new YubiKey.  
8. Specify how long the key should be valid for **10y**  
9. Confirm the expiration day. 
10. When prompted, enter your name.
11. Enter your email address.  
12. Leave comment blank. Just hit **enter**.  
13. Review the name and email, and enter **O** to accept or make changes.
14. Enter the default admin PIN again. The green light on the YubiKey will flash while the keys are being written.  This process can take a little while.  Create entropy (move mouse, move windows, create disk activity) on your computer to speed things up.  
15. At the **gpg/card>** prompt, enter the command: **quit**  
16. Make offline backups of revocation and signature key stub.



## Yubikey Usage Info
[Yubikey usage](yubikey_usage.md) 