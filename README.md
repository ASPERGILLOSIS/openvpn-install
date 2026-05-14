# openvpn-install

Fork of [Nyr/openvpn-install](https://github.com/Nyr/openvpn-install).

This fork keeps upstream `openvpn-install.sh` as the base and carries the local installed-server menu behavior as a patch. The goal is to keep future upstream updates easy: update the upstream script first, then re-apply the menu patch.


## Install

Run the installer from this fork with:

```bash
wget https://raw.githubusercontent.com/ASPERGILLOSIS/openvpn-install/menu-customizations/openvpn-install.sh -O openvpn-install.sh && chmod +x openvpn-install.sh && bash openvpn-install.sh
```

## What the patch changes

The patch only targets the menu shown when OpenVPN is already installed, near the bottom of `openvpn-install.sh`. It does not intentionally change the initial OpenVPN installation flow, package installation, firewall setup, certificate defaults, DNS setup, or server configuration generation.

The visible installed-server menu becomes:

```text
1) Add a new client
2) Revoke an existing client
3) Continuously revoke clients
4) Continuously add clients
5) Exit
```

## Local behavior

- Add clients using the same upstream certificate and `.ovpn` generation behavior.
- Revoke clients by exact username instead of numeric selection.
- Accept `name` or `name.ovpn` when revoking.
- List valid, non-revoked clients before asking which client to revoke.
- Delete exported `.ovpn` files after successful revocation from common locations, including the script directory, root home, current user home expansion, and `/etc/openvpn/client-configs/files`.
- Support continuous revoke until Enter is pressed at the client-name prompt.
- Support continuous add without an "Add another client?" prompt. Use Ctrl+C to leave that loop.

## OpenVPN removal

The upstream removal code is kept, but it is hidden from the visible menu to reduce accidental removal. To remove OpenVPN, type this at the option prompt:

```text
remove
```

## Update from upstream

From this branch, update the upstream base and re-apply the local patch:

```bash
git fetch upstream
git rebase upstream/master
./scripts/apply-menu-patch.sh
bash -n openvpn-install.sh
```

If the patch is already applied, the script will say so. If upstream changes the same installed-server menu block, the script will stop and report that the patch does not apply cleanly. In that case, update `patches/menu-only.patch` against the new upstream menu.

## Regenerate the patch after editing

After changing `openvpn-install.sh`, regenerate the patch file from the current Git diff:

```bash
git diff upstream/master -- openvpn-install.sh > patches/menu-only.patch
```

Then verify and commit:

```bash
bash -n openvpn-install.sh
./scripts/apply-menu-patch.sh
git add openvpn-install.sh patches/menu-only.patch README.md
git commit --amend --no-edit
```
