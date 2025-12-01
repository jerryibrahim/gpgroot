# Yubikey usage information

## Create public ssh key and copy to remote computer’s authorized_keys

1. Generate public ssh key
2. Create phantom private to enable ssh-copy-id to work

```bash
> cd ~/.ssh
> ssh-add -L > username_yubi.pub
> cp username_yubi.pub username_yubi
> chmod 600 username_yubi
```

**Optional:** copy to remote system’s ~/.ssh/authorized_keys

```bash
> ssh-copy-id -i username_yubi.pub user@hostname
```

## Setup GIT for GPG signing

1. Login into Github, Gitlab, Bitbucket and upload GPG public key **publickey.txt**
2. Use last 16 chars of signature key and configure git

```bash
> gpg --list-secret-keys --keyid-format LONG  # Capture 16 chars after rsa4096/ of signature key
> gpg --list-secret-keys --keyid-format LONG | grep "\[S\]" | awk '{print $2}' | cut -c9-24
> git config --global user.signingkey <16 chars>
> git config --global commit.gpgsign true

> git log --show-signature  # To verify git commit has signature
```

## GPG Forwarding to remote server

[Yubikey GPG Forwarding and sudo](yubikey_forwarding.md)

## Publish Public GPG key to keyserver

```bash
> gpg --keyserver keys.openpgp.org --send-key user@domain.com
```

## Import Someone's Public GPG Key

Import a file that is distributed to you or you can search from a keyserver.

```bash
> gpg --import someone_publickey.txt
> gpg --keyserver keys.openpgp.org --search someone@else.com
> gpg --keyserver keys.openpgp.org --recv-keys <fingerprint>

# Now check the <fingerprint> against authorized list

> gpg --edit-key <fingerprint>

gpg> lsign  (for local signing, non-exportable)
- or -
gpg> tsign  (Select I trust fully, select depth, then enter GPG Passphrase, then update key server)

```

## Encrypt / Decrypt with GPG

Verify signature file \<filename.asc\> with the actual file \<filename\>

```bash
> gpg --encrypt --sign --recipient <someone@else.com> <filename>  (encrypted output is <filename>.gpg)

> gpg --decrypt <filename).gpg
> gpg --decrypt <filename).gpg --default-key <key>

> gpg --verify <filename.asc> <filename>
```
