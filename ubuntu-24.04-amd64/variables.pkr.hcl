##### Required Variables #####

variable "proxmox_host" {
  type        = string
  description = "The Proxmox host or IP address."
  default     = "pve1.example.com"
}

##### Optional Variables #####

variable "proxmox_port" {
  type        = number
  description = "The Proxmox port."
  default     = 8006
}

variable "proxmox_skip_verify_tls" {
  type        = bool
  description = "Skip validating the Proxmox certificate."
  default     = false
}

variable "proxmox_node" {
  type        = string
  description = "Which node in the Proxmox cluster to start the virtual machine on during creation."
  default     = "pve1"
}

variable "proxmox_node_host" {
  type        = string
  description = "To use as ssh bastion host address."
  default     = "pve1.example.com"
}

variable "proxmox_node_ssh_port" {
  type        = number
  description = "To use as ssh bastion host port."
  default     = 22
}

variable "proxmox_node_ssh_username" {
  type        = string
  description = "To use as ssh bastion host port."
  default     = "root"
}

variable "proxmox_pool" {
  type        = string
  description = "Proxmox pool."
  default     = "packer_pool"
}

variable "template_name" {
  type        = string
  description = "The VM template name."
  default     = "base-template-ubuntu-24.04-cloud-init"
}

variable "template_description" {
  type        = string
  description = "Description of the VM template."
  default     = "Base template for Ubuntu 24.04 (cloud-init)."
}

variable "ssh_username" {
  type        = string
  description = "The username to connect to SSH with."
  default     = "packer"
}

variable "ssh_password" {
  type        = string
  description = "A plaintext password to use to authenticate with SSH."
  default     = "packer"
}

variable "ssh_private_key_file" {
  type        = string
  description = "Path to private key file for SSH authentication."
  default     = null
}

variable "ssh_public_key" {
  type        = string
  description = "Public key data for SSH authentication. If set, password authentication will be disabled."
  default     = null
}

variable "ssh_agent_auth" {
  type        = bool
  description = "Whether to use an exisiting ssh-agent to pass in the SSH private key passphrase."
  default     = false
}

variable "disk_storage_pool" {
  type        = string
  description = "Storage pool for the boot disk and cloud-init image."
  default     = "local-zfs"

  validation {
    condition     = var.disk_storage_pool != null
    error_message = "The disk storage pool must not be null."
  }
}

variable "disk_size" {
  type        = string
  description = "The size of the OS disk, including a size suffix. The suffix must be 'K', 'M', or 'G'."
  default     = "8G"

  validation {
    condition     = can(regex("^\\d+[GMK]$", var.disk_size))
    error_message = "The disk size is not valid. It must be a number with a size suffix (K, M, G)."
  }
}

variable "disk_format" {
  type        = string
  description = "The format of the file backing the disk."
  default     = "raw"

  validation {
    condition     = contains(["raw", "cow", "qcow", "qed", "qcow2", "vmdk", "cloop"], var.disk_format)
    error_message = "The storage pool type must be either 'raw', 'cow', 'qcow', 'qed', 'qcow2', 'vmdk', or 'cloop'."
  }
}

variable "disk_type" {
  type        = string
  description = "The type of disk device to add."
  default     = "scsi"

  validation {
    condition     = contains(["ide", "sata", "scsi", "virtio"], var.disk_type)
    error_message = "The storage pool type must be either 'ide', 'sata', 'scsi', or 'virtio'."
  }
}

variable "memory" {
  type        = number
  description = "How much memory, in megabytes, to give the virtual machine."
  default     = 4096
}

variable "ballooning_minimum" {
  type        = number
  description = "How much memory, in megabytes, to give the virtual machine."
  default     = 512
}

variable "cores" {
  type        = number
  description = "How many CPU cores to give the virtual machine."
  default     = 2
}

variable "sockets" {
  type        = number
  description = "How many CPU sockets to give the virtual machine."
  default     = 1
}

variable "iso_url" {
  type        = string
  description = "URL to an ISO file to upload to Proxmox, and then boot from."
  default     = "https://releases.ubuntu.com/24.04/ubuntu-24.04-live-server-amd64.iso"
}

variable "iso_storage_pool" {
  type        = string
  description = "Proxmox storage pool onto which to find or upload the ISO file."
  default     = "local"
}

variable "iso_checksum" {
  type        = string
  description = "Checksum of the ISO file."
  default     = "sha256:8762f7e74e4d64d72fceb5f70682e6b069932deedb4949c6975d0f0fe0a91be3"
}

variable "network_bridge" {
  type        = string
  description = "The Proxmox network bridge to use for the network interface."
  default     = "vmbr0"
}

variable "cloud_init_storage_pool" {
  type        = string
  description = "Name of the Proxmox storage pool to store the Cloud-Init CDROM on. If not given, the storage pool of the boot device will be used (disk_storage_pool)."
  default     = "local-zfs"
}

variable "cloud_init_apt_packages" {
  type        = list(string)
  description = "A list of apt packages to install during the subiquity cloud-init installer."
  default     = []
}

variable "locale" {
  type        = string
  description = "The system locale set during the subiquity install."
  default     = "en_US"
}

variable "keyboard_layout" {
  type        = string
  description = "Sets the keyboard layout during the subiquity install."
  default     = "us"
}

variable "timezone" {
  type        = string
  description = "Sets the timezone during the subiquity install."
  default     = "Etc/UTC"
}

variable "ip_addr" {
  type        = string
  description = "Temporary IP address for VM."
  default     = "10.10.10.254/24"
}

variable "default_gw" {
  type        = string
  description = "Default gateway."
  default     = "10.10.10.1"
}

variable "search_domain" {
  type        = string
  description = "Search domain."
  default     = "example.com"
}

variable "dns_server_primary" {
  type        = string
  description = "Primary DNS server."
  default     = "1.1.1.1"
}

variable "dns_server_secondary" {
  type        = string
  description = "Secondary DNS server."
  default     = "8.8.8.8"
}
