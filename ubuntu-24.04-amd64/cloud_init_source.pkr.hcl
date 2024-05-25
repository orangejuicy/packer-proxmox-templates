source "file" "meta_data" {
  source = "${path.root}/templates/meta-data.pkrtpl"
  target = "${path.root}/iso/meta-data"
}

source "file" "user_data" {
  content = templatefile("templates/user-data.pkrtpl", {
    locale                  = var.locale
    timezone                = var.timezone
    keyboard_layout         = var.keyboard_layout
    ip_addr                 = var.ip_addr
    search_domain           = var.search_domain
    dns_server_primary      = var.dns_server_primary
    dns_server_secondary    = var.dns_server_secondary
    default_gw              = var.default_gw
    ssh_username            = var.ssh_username
    ssh_password            = bcrypt(var.ssh_password)
    cloud_init_apt_packages = var.cloud_init_apt_packages
  })
  target = "${path.root}/iso/user-data"
}
