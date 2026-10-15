# Arcane for Home Assistant OS (prototype add-on)

This repository adapts the supplied HA Dockhand add-on structure to run the official Arcane Manager binary inside a Home Assistant add-on container. It does **not** mount `/var/run/docker.sock` and is intended to manage **remote Docker hosts only**.

## Important status

This is an experimental prototype, not a verified release. Arcane's manager is copied from the official `ghcr.io/getarcaneapp/manager` image. Ingress uses an nginx compatibility rewrite, but Arcane's current frontend/API routing has not been runtime-tested behind Home Assistant Ingress. If it does not load correctly, use a dedicated reverse proxy / direct URL rather than assuming Ingress compatibility.

## Install for local development

1. Copy the `arcane` folder into a Home Assistant add-on repository.
2. Update the repository `repository.yaml` URL/maintainer to your own Git repository.
3. Add the repository under **Settings → Apps → Repositories**.
4. Install **Arcane** and start it.
5. On first start, the add-on generates and persists an `ENCRYPTION_KEY` in `/data/.encryption_key` if you leave the option blank. Back up `/data` and keep this key safe; losing it can make encrypted Arcane data unreadable.

## Add remote VMs

For each VM on the same LAN:

1. Ensure Docker is installed and working on the VM.
2. In Arcane, open **Environments → Add Environment → Direct**.
3. Use the VM's stable LAN address and port `3553` as the Agent API URL (for example `http://192.168.1.50:3553`).
4. Copy the generated agent configuration from Arcane and run it on the VM. The official agent image is `ghcr.io/getarcaneapp/agent:latest`.
5. Restrict TCP/3553 to the Home Assistant host in the VM firewall; do not expose it to the internet.

Arcane's own UI generates the agent token and the exact Compose configuration. Do not reuse example tokens.

## Limitations

- The add-on intentionally has no Docker socket/device access and cannot manage Home Assistant OS's own Docker host; only remote environments are intended.
- `APP_URL` is currently loopback for internal operation. Verify login redirects, assets, API requests, and event streams in Ingress on your installed Arcane version before relying on it.
- The manager image tag is `latest`; pin a tested Arcane version before production use.
- A production repository should include a built image reference in `config.yaml` and CI for both `amd64` and `aarch64`.
