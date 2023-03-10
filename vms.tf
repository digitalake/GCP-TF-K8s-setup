resource "google_compute_address" "static_ip" {
  for_each = var.vms
  name     = "${var.project_alias}-ipv4-${each.key}"
}

resource "google_compute_disk" "custom_disk" {
  for_each = var.vms
  project  = var.gcp_project
  name     = "${var.project_alias}-data1-${each.key}"
  type     = each.value.disk_type
  zone     = var.gcp_zone
  size     = each.value.disk_size

}

resource "google_compute_instance" "vm_instance" {
  for_each     = var.vms
  name         = "${var.project_alias}-${each.key}"
  machine_type = each.value.instance_type
  zone         = var.gcp_zone
  tags         = ["ssh", "internall-all"]
  boot_disk {
    initialize_params {
      image = each.value.boot_disk_image
    }
  }
  attached_disk {
    source = google_compute_disk.custom_disk[each.key].id
  }
  metadata = {
    ssh-keys = "${each.value.ssh_user}:${file("${each.value.ssh_pub_key}")}"
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnetwork.name
    access_config {
      nat_ip = google_compute_address.static_ip[each.key].address
    }
  }
}
