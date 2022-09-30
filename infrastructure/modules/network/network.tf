# Main VPC
resource "google_compute_network" "mainvpc" {
  name                    = "mainvpc"
  auto_create_subnetworks = false
}

# Cloud Router
resource "google_compute_router" "router" {
  name    = "router"
  network = google_compute_network.mainvpc.name
  bgp {
    asn            = 64514
    advertise_mode = "CUSTOM"
  }
}

# Public Subnet  
resource "google_compute_subnetwork" "public" {
  name          = "public"
  ip_cidr_range = "192.168.0.0/24"
  network       = google_compute_network.mainvpc.id
}


# Private Subnet  
resource "google_compute_subnetwork" "private" {
  name          = "private"
  ip_cidr_range = "192.168.1.0/24"
  network       = google_compute_network.mainvpc.id
}

# NAT Gateway
resource "google_compute_router_nat" "nat" {
  name                               = "nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.private.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

