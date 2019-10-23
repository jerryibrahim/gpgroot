# Generating Your PGP Key directly on Your YubiKey
Warning: Generating the PGP on the YubiKey ensures that malware can never steal your PGP private key, but it means that the key can not be backed up so if your YubiKey is lost or damaged the PGP key is irrecoverable.  [source](https://support.yubico.com/support/solutions/articles/15000006420-using-your-yubikey-with-openpgp) 



## Setup Mac for Yubikey and GPG

```
> brew cask install gpg-suite
> brew install gnupg ykman ykpers libyubikey yubico-piv-tool ykneomgr
> which gpg2 (check if gpg2 is already installed, if not brew install gpg2)
```

## Instructions

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