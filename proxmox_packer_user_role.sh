#!/usr/bin/env bash

set -e

pveum useradd packer@pve
pveum passwd packer@pve
pveum roleadd Packer -privs "VM.Allocate VM.Console VM.Config.Memory VM.Clone Sys.Audit VM.Config.Network VM.Config.Cloudinit VM.Config.CPU VM.PowerMgmt Datastore.AllocateTemplate VM.Monitor VM.Config.Options VM.Audit VM.Config.HWType Datastore.AllocateSpace Datastore.Allocate VM.Config.CDROM Sys.Modify VM.Config.Disk Datastore.Audit Group.Allocate Permissions.Modify Pool.Allocate Pool.Audit Realm.Allocate Realm.AllocateUser SDN.Allocate SDN.Audit SDN.Use Sys.Console Sys.Incoming Sys.PowerMgmt Sys.Syslog User.Modify VM.Backup VM.Migrate VM.Snapshot VM.Snapshot.Rollback"
pveum aclmod / -user packer@pve -role Packer
