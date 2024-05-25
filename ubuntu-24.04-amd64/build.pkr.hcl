build {
  sources = [
    "source.file.meta_data",
    "source.file.user_data",
    "source.proxmox-iso.ubuntu"
  ]

  # Wait for cloud-init to complete after reboot
  provisioner "shell" {
    inline = ["while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"]
  }

  # Clean up subiquity installer
  provisioner "shell" {
    environment_vars = [
      "SSH_USERNAME=${var.ssh_username}"
    ]
    skip_clean = true
    #execute_command = "sudo /bin/sh -c '{{ .Vars }} {{ .Path }}'"
    execute_command = "chmod +x {{ .Path }}; sudo env {{ .Vars }} {{ .Path }}; rm -f {{ .Path }}"
    inline = [
      "systemctl stop unattended-upgrades",
      "systemctl disable unattended-upgrades",
      "cloud-init clean",
      "rm -f /etc/sudoers.d/90-cloud-init-users",
      "if [ -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg ]; then rm /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg; echo 'Deleting subiquity cloud-init network config'; fi",
      "if [ -f /etc/cloud/cloud-init.disabled ]; then rm /etc/cloud/cloud-init.disabled; echo 'Deleting cloud-init.disabled config'; fi",
      "userdel -f -r $SSH_USERNAME"
    ]
  }
}
