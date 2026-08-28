/**
 * Copyright 2026 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# Natively provision a Debian micro VM instance inside your new 'lon-dev-project-0' project
# and connect it securely to your London VPC spoke.

provider "google" {
  # Runs under your active, highly-privileged gcloud CLI user (justin@placard.media),
  # bypassing any complicated platform service-account impersonation!
}

resource "google_compute_instance" "debian_micro" {
  project      = var.project_ids["lon-dev-project-0"]
  name         = "lon-dev-debian-micro"
  machine_type = "e2-micro"       # Smallest, free-tier eligible instance
  zone         = "europe-west2-a" # London, UK zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-12"
      type  = "pd-standard"
      size  = 10
    }
  }

  network_interface {
    # Keyed by filesystem VPC key "london" and regional subnet name "europe-west2/subnet-london"
    subnetwork = var.subnet_self_links["london"]["europe-west2/subnet-london"]
    # No public IP is assigned! It routes outbound internet traffic securely
    # through the VPC to your London Cloud NAT gateway.
  }

  metadata = {
    enable-oslogin = "TRUE"
  }
}
