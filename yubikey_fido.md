# Securing SSH with FIDO2 Yubikey

## Setup Yubikey FIDO PIN

```bash
> ykman fido access change-pin  [recommend same as PIV PIN]
> ykman fido access verify-pin
> ykman fido info
```

## Create ssh key pair using FIDO2

```bash
> ssh-keygen -t ed25519-sk -O resident -O verify-required -C "FIDO2 cardno:12 345 678"
```

**Prompts:**

Authentication Options:

```bash
-O resident -O no-touch-required                       # No Pin and No Touch
-O resident -O verify-required -O no-touch-required    # Pin and No Touch
-O resident                                            # No Pin and Touch
-O resident -O verify-required                         # Pin and Touch  - Most Secure
```

Replace cardno: with Yubikey serial number from "ykman info"  
Provide PIN and touch the security key  
Press Enter to accept default filename [recommend unique filename for yubikey]  
Press Enter (twice) to store files without a passphrase

## Help

```bash
> eval "$(ssh-agent -s)"  # restart ssh agent
> ssh-add                 # add keys to agent
> ssh-add -l              # list keys in agent
```

[Yubico Securing SSH with FIDO2](https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html)
