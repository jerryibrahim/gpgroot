# Setup Yubikey from offline key generation

## Setup Mac for Yubikey and GPG

```bash
brew install --cask gpg-suite
brew install gnupg ykman ykpers libyubikey yubico-piv-tool
```

## Import GPG keys

Insert Yubikey into usb port. Copy contents to ~/Documents/keys

```bash
mkdir ~/Documents/keys
cd ~/Documents/keys

# copy your keys from usb drive to the new keys folder just created

ykman list  (shows serial of Yubikey)
gpg --import masterstubs.txt  [enter passphrase]
gpg --import subkeysstubs.txt
gpg --import publickey.txt
gpg --edit-key user@domain.com
```

**Prompts:**

- gpg> **trust**
- Your decision? **5** (I trus ultimately)
- Do you really want to set this key to ultimate trust? (y/N) **y**
- gpg> **quit**

Should see Yubikey info and gpg keys

```bash
gpg --card-status
```

## Setup Yubikey PIV PIN

1. Change Yubikey PIN: [default 123456, keep to 6 digits]
2. Change Yubikey Admin PUK: [default 12345678, keep to 8 digits]
3. Change PIN|PUK retries to 5

```bash
> yubico-piv-tool -a change-pin
> yubico-piv-tool -a change-puk
> yubico-piv-tool -a verify -a pin-retries --puk-retries=5 --pin-retries=5
```

## Setup Yubikey GPG PIN

```bash
gpg --card-edit
```

**Prompts:**

- gpg/card> **admin**
- gpg/card> **passwd**
- Your selection? **3** [change Admin PIN, default 12345678, recommend same as PUK PIN]
- Your selection? **1** [change PIN, default 123456, recommend same as PIV PIN]
- Your selection? **q** [quit]
- gpg/card> **name**
- Cardholder's surname: **Lastname**
- Cardholder's given name: **Firstname**
- gpg/card> **quit** [enter admin PIN when prompted]

## Launch gpg-agent in ssh emulation mode at login

Append the following to ~/.gnupg/gpg-agent.conf  
Use "gpgconf --list-dirs agent-extra-socket" to get <LOCAL_SOCKET_EXTRA>

> default-cache-ttl-ssh 600  
> max-cache-ttl-ssh 7200  
> pinentry-program /usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac  
> enable-ssh-support
> extra-socket <LOCAL_SOCKET_EXTRA>

```bash
echo -e "\n# Added for Yubikey support\ndefault-cache-ttl-ssh 600\nmax-cache-ttl-ssh 7200\npinentry-program /usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac\nenable-ssh-support\nextra-socket $(gpgconf --list-dirs agent-extra-socket)\n" >> ~/.gnupg/gpg-agent.conf
```

## Update terminal profiles

Update your .bash_profile, .zprofile. You will need to restart your shell or source your profile script.  
Append the following to ~/.bash_profile (or other profile script)  
Use "gpgconf --list-dirs agent-ssh-socket" to get <LOCAL_SOCKET_SSH>

> export LANG=en  
> export LC_ALL=en_US.UTF-8  
> export GPG_TTY=$(tty)  
> export SSH_AUTH_SOCK=<LOCAL_SOCKET_SSH>  
> gpg-agent --daemon  
> alias gpgreset='gpg-connect-agent killagent /bye; gpg-connect-agent updatestartuptty /bye; gpg-connect-agent /bye'

### bash profile

```bash
echo -e "\n# Added for Yubikey support\nexport LANG=en\nexport LC_ALL=en_US.UTF-8\nexport GPG_TTY=$(tty)\nexport SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)\ngpg-agent --daemon\n\nalias gpgreset='gpg-connect-agent killagent /bye; gpg-connect-agent updatestartuptty /bye; gpg-connect-agent /bye'\n" >> ~/.bash_profile
```

### zsh profile

```bash
echo -e "\n# Added for Yubikey support\nexport LANG=en\nexport LC_ALL=en_US.UTF-8\nexport GPG_TTY=$(tty)\nexport SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)\ngpg-agent --daemon\n\nalias gpgreset='gpg-connect-agent killagent /bye; gpg-connect-agent updatestartuptty /bye; gpg-connect-agent /bye'\n" >> ~/.zprofile
```

Exit terminal and restart terminal shell

## Setup Yubikey to auto eject after 5 min

```bash
ykman config usb --autoeject-timeout 300
```

## Yubikey Usage Info

[Yubikey usage](yubikey_usage.md)

## LEGACY - Use gpg-agent instead of ssh-agent

## Disable ssh-agent at login

```bash
sudo launchctl disable user/username/com.openssh.ssh-agent -w

- or -

mdfind ssh-agent|grep plist
launchctl unload -w /System/Library/LaunchAgents/com.openssh.ssh-agent.plist
sudo launchctl disable system/com.openssh.ssh-agent
```
