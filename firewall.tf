# allow http
resource "google_compute_firewall" "allow_http" {
  name    = "${var.project_alias}-allow-http"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = var.frwll_src_range
  target_tags   = ["http"]
}

#allow icmp
resource "google_compute_firewall" "allow_icmp" {
  name    = "${var.project_alias}-allow-icmp"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "icmp"
  }
  source_ranges = var.frwll_src_range
  target_tags   = ["icmp"]
}

# allow https
resource "google_compute_firewall" "allow_https" {
  name    = "${var.project_alias}-allow-https"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = var.frwll_src_range
  target_tags   = ["http"]

}

# allow ssh
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.project_alias}-allow-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = var.frwll_src_range
  target_tags   = ["ssh"]
}

# allow rdp
resource "google_compute_firewall" "allow_rdp" {
  name    = "${var.project_alias}-allow-rdp"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  source_ranges = var.frwll_src_range
  target_tags   = ["rdp"]
}

#allow kube
resource "google_compute_firewall" "allow_kube" {
  name    = "${var.project_alias}-allow-kube"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }
  source_ranges = var.frwll_src_range
  target_tags   = ["kube"]
}