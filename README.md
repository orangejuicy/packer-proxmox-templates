# packer-proxmox-templates
Proxmox Ubuntu cloud-init image built with Packer

Changes to the original repository:

 * Added functionality to pass cloud-config with an additional ISO image instead of using Packer's web server.
 * Implemented the use of a bastion SSH host (PVE node) to access the VM SSH server. Useful when VM is behind a NAT.
 * Enabled the usage of the local SSH agent to access the bastion SSH host.
 * Added a .devcontainer packer image and a wrapper script.
 * Disabled unattended-upgrades service and enabled cloud-init for the produced template.

## Adding packer user with correct privileges

```
pveum useradd packer@pve
pveum passwd packer@pve
pveum roleadd Packer -privs "VM.Allocate VM.Console VM.Config.Memory VM.Clone Sys.Audit VM.Config.Network VM.Config.Cloudinit VM.Config.CPU VM.PowerMgmt Datastore.AllocateTemplate VM.Monitor VM.Config.Options VM.Audit VM.Config.HWType Datastore.AllocateSpace Datastore.Allocate VM.Config.CDROM Sys.Modify VM.Config.Disk Datastore.Audit Group.Allocate Permissions.Modify Pool.Allocate Pool.Audit Realm.Allocate Realm.AllocateUser SDN.Allocate SDN.Audit SDN.Use Sys.Console Sys.Incoming Sys.PowerMgmt Sys.Syslog User.Modify VM.Backup VM.Migrate VM.Snapshot VM.Snapshot.Rollback"
pveum aclmod / -user packer@pve -role Packer
```

## Prerequisites

 * Docker
 * https://github.com/devcontainers/cli

## Environment variables

 * `PROXMOX_HOST` - pve api hostname
 * `PROXMOX_NODE` - pve node name
 * `PROXMOX_NODE_HOST` - pve node hostname or ip address
 * `PROXMOX_USERNAME` - pve username
 * `PROXMOX_TOKEN` - token (or `PROXMOX_PASSWORD` to use the password)
 * `PROXMOX_NODE_SSH_USERNAME` - pve node ssh username (for a bastion host)
 * `PROXMOX_NODE_SSH_PORT` - pve node ssh port (for a bastion host)

## Run

```
eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa
./run.sh
```
