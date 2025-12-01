# Setup Yubikey GPG Forwarding and sudo

1. Enable Yubikey to be used for remote server sudo validation (instead of typing password)
2. Enable Yubikey for GPG signing on remote server (for git commits)

## Step 1 - Setup GPG Agent Forwarding

To get correct paths run the following

```bash
# Local machine (use extra socket for forwarding)
gpgconf --list-dirs agent-extra-socket  # <LOCAL_SOCKET_EXTRA>
gpgconf --list-dirs agent-ssh-socket    # <LOCAL_SOCKET_SSH>

# Remote machine (where the forwarded socket will land)
gpgconf --list-dirs agent-socket        # <REMOTE_SOCKET>
gpgconf --list-dirs agent-ssh-socket    # <REMOTE_SOCKET_SSH>
```

Make sure your `~/.gnupg/gpg-agent.conf` has

```term
enable-ssh-support
extra-socket <LOCAL_SOCKET_EXTRA>
```

Edit local `.ssh/config` for configured hosts

```term
Host <remote-server>
  HostName <remote.example.com>
  User <username>
  ForwardAgent yes
  RemoteForward <REMOTE_SOCKET> <LOCAL_SOCKET_EXTRA>
  RemoteForward <REMOTE_SOCKET_SSH> <LOCAL_SOCKET_SSH>
```

On the Remote Server edit `/etc/ssh/sshd_config`

```term
StreamLocalBindUnlink yes
```

Restart SSH on the Remote Server

```bash
sudo systemctl restart sshd
```

## Step 2 - Configure PAM for `sudo` with SSH Agent Auth

Install the PAM Modudle on the remote server

```bash
sudo apt update
sudo apt install libpam-ssh-agent-auth
```

On your local machine, get the SSH public key from your YubiKey's auth subkey (probably can skip step)

```bash
gpg --export-ssh-key YOUR_KEY_ID
```

On remote server, create the authorized keys file for `sudo`

```bash
sudo mkdir -p /etc/security
sudo vim /etc/security/authorized_keys # Paste your public key here
sudo chmod 644 /etc/security/authorized_keys
```

On remote server, configure PAM in `/etc/pam.d/sudo`

```bash
sudo vim /etc/pam.d/sudo
```

Add this line **at the very top**, before other `auth` lines:

```term
auth    sufficient    pam_ssh_agent_auth.so file=/etc/security/authorized_keys
```

The file should look something like:

```term
auth    sufficient    pam_ssh_agent_auth.so file=/etc/security/authorized_keys
@include common-auth
@include common-account
@include common-session-noninteractive
```

On remote server, Allow `sudo` to Access the SSH Agent Socket

```bash
sudo EDITOR=vim visudo
```

Add this line in the `Defaults` section:

```term
Defaults    env_keep += "SSH_AUTH_SOCK"
```

## Step 3 - Ensure the remote server uses the forwarded socket

On remote server, add to your `~/.bashrc` or `~/.profile`

```bash
echo -e "\n# Added for Yubikey SSH Agent Forwarding\nexport SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)\n" >> ~/.bashrc
```

The remote profile should have this at the end

```term
.
.
.

# Added for Yubikey SSH Agent Forwarding
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
```

## Step 4 - Import your public GPG key on the remote server

This step will enable GPG operations to work remotely

On your local machine, get the GPG public key from your YubiKey's auth subkey (probably can skip step)

```bash
gpg --armor --export YOUR_KEY_ID > gpg.pubkey.txt

# Copy to remote server
scp gpg.pubkey.txt remote:~
```

On remote server, import and trust the public key

```bash
gpg --import gpg.pubkey.txt
gpg --edit-key YOUR_KEY_ID trust  # Set trust level to ultimate
```

On remote server, Setup GIT for GPG signing from [Yubikey usage](yubikey_usage.md)

## Step 5 - Validate Configuration

On remote server run the following after SSHing in a new terminal session

```bash
# Verify GPG can see your key
gpg --list-secret-keys --keyid-format LONG  # Should show your YubiKey keys

# Test signing
echo "test" | gpg --sign --armor   # Should prompt for YubiKey touch locally

# Test git
git commit --allow-empty -m "Test signed commit"   # Touch YubiKey locally
git log --show-signature -1   # Verify signature


# Troubleshooting
# Check the socket exists on remote
ls -la $(gpgconf --list-dirs agent-socket)

# Check your GPG agent is responding
gpg-connect-agent 'keyinfo --list' /bye

```
