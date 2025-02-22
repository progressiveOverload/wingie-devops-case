provider "google" {
  project = "PROJECT_ID"
  region  = "europe-west1"
}

resource "google_container_cluster" "gke_cluster" {
  name     = "wingie-case-gke-cluster"
  location = "europe-west1-b"

  remove_default_node_pool = true
  initial_node_count       = 1

  logging_service    = "none"
  monitoring_service = "none"

  network    = "default"
  subnetwork = "default"
}

resource "google_container_node_pool" "main_pool" {
  name       = "main-pool"
  cluster    = google_container_cluster.gke_cluster.id
  location   = "europe-west1-b"
  node_count = 1

  node_config {
    machine_type = "n2d-standard-2"
    preemptible  = false
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_container_node_pool" "application_pool" {
  name       = "application-pool"
  cluster    = google_container_cluster.gke_cluster.id
  location   = "europe-west1-b"

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "n2d-standard-2"
    preemptible  = false
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
