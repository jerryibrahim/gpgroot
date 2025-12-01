# GPG Setup with Yubikey

There are many ways to generate GPG keys, but care must be take to generate the keys in such a way that the privates keys are never exposed. There are 2 general approaches that are secure and each with their trade-offs.

## Option 1 - Offline Key Generation

**Pros:** GPG keys can be restored onto multiple Yubikeys. This is usually important if you have a need to keep a long lived encryption key that would be used to decrypt older files. The other major benefit is that you can maintain a long lived signature that can be trusted over time.

**Cons:** This would require setting up an offline server for key generation and secure offline devices for holding the key material. This is a much more time consuming process.

Step 1: [Offline server setup](offline_server_setup.md)  
Step 2: [Offline key generation](offline_keygen.md)  
Step 3: [Import keys onto new computer](yubikey_from_offline.md)

## Option 2 - Yubikey Key Generation

**Pros:** GPG keys are created directly inside the Yubikey and the private keys are safely protected from the computer. This will meet most people's needs for MFA authentication. If the Yubikey is damaged or lost, a new auth key can be provisioned and the old ssh public keys can be rotated. This process is much faster and easier.

**Cons:** There is no way possible to restore the GPG keys to a new Yubikey. Must have multiple authorized keys (from other Yubikeys) on the remote server incase the Yubikey gets damaged.

Setup instructions for GPG key generation inside Yubikey: [Yubikey keygen](yubikey_keygen.md)

## Securing SSH with FIDO2 Yubikey

[Create FIDO SSH Keys](yubikey_fido.md)
