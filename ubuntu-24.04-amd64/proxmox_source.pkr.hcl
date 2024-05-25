source "proxmox-iso" "ubuntu" {
  proxmox_url = "https://${var.proxmox_host}:${var.proxmox_port}/api2/json" # PROXMOX_URL

  node = var.proxmox_node
  pool = var.proxmox_pool

  communicator         = "ssh"
  ssh_bastion_host     = var.proxmox_node_host
  ssh_bastion_port     = var.proxmox_node_ssh_port
  ssh_bastion_username = var.proxmox_node_ssh_username
  #ssh_bastion_password = ""
  ssh_bastion_agent_auth = true
  #ssh_bastion_interactive = true

  ssh_handshake_attempts    = 100
  ssh_username              = var.ssh_username
  ssh_password              = var.ssh_password
  ssh_clear_authorized_keys = true
  ssh_timeout               = "45m"

  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  iso_storage_pool = var.iso_storage_pool
  iso_download_pve = true
  unmount_iso      = true

  additional_iso_files {
    device           = "scsi5"
    unmount          = true
    iso_storage_pool = var.iso_storage_pool
    cd_files         = ["${path.root}/iso/*"]
    cd_label         = "cidata"
  }

  #boot
  #"autoinstall ip=10.10.10.254 net.ifnames=0 biosdevname=0 ipv6.disable=1 ds='nocloud-net;s=${local.http_url}/' ---",

  boot_command = [
    "e<wait>",
    "<down><down><down><end>",
    "<bs><bs><bs><bs><wait>",
    "autoinstall ip=10.10.10.254::10.10.10.1:255.255.255.0::::8.8.8.8 ipv6.disable=1 ---",
    "<wait><f10><wait>"
  ]

  boot_wait = "10s"
  #boot_keygroup_interval


  task_timeout = "5m"

  os         = "l26"
  qemu_agent = true

  template_name           = var.template_name
  template_description    = var.template_description
  cloud_init              = true
  cloud_init_storage_pool = var.cloud_init_storage_pool

  network_adapters {
    model  = "virtio"
    bridge = var.network_bridge
  }

  scsi_controller = "virtio-scsi-pci"

  disks {
    disk_size    = var.disk_size
    format       = var.disk_format
    storage_pool = var.disk_storage_pool
    type         = var.disk_type
    cache_mode   = "none"
    discard      = true
    ssd          = true
  }

  memory             = var.memory
  ballooning_minimum = var.ballooning_minimum
  cores              = var.cores
  sockets            = var.sockets

  #cpu_type
  #numa
  #bios
  #efi_config
  #efidisk
  #machine

  onboot = false

  vga {
    type = "std"
    #memory = 32
  }

  #pci_devices
  #serials
}
