resource "google_compute_firewall" "allow_internal-all" {
  name    = "${var.project_alias}-allow-internal-all"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "all"
  }
  source_ranges = [var.subnet_cidr] # pointing rule on subnet cidr block
  target_tags   = ["internall-all"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.project_alias}-allow-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = var.frwll_src_range # global range
  target_tags   = ["ssh"]
}

# OPTIONAL if using windows machine as a host for connections to vms
# allow rdp
#resource "google_compute_firewall" "allow_rdp" {
#  name    = "${var.project_alias}-allow-rdp"
#  network = google_compute_network.vpc_network.name
#  allow {
#    protocol = "tcp"
#    ports    = ["3389"]
#  }
#  source_ranges = var.frwll_src_range
#  target_tags   = ["rdp"]
#}
