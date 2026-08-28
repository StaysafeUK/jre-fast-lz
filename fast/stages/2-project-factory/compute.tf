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

# Natively provision a Debian micro VM instance inside the newly created service project
# and connect it securely to your London VPC spoke.

resource "google_compute_instance" "debian_micro" {
  project      = module.factory.project_ids["lon-dev-project-0"]
  name         = "lon-dev-debian-micro"
  machine_type = "e2-micro"       # Small, cost-efficient micro instance
  zone         = "europe-west2-a" # London, UK zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-12"
      type  = "pd-balanced"
      size  = 10
    }
  }

  network_interface {
    subnetwork = var.subnet_self_links["vpc-spoke-london/subnet-london"]
    # Outbound internet is securely provided via local Cloud NAT (no public IP needed!)
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  # Ensure the VM is only created after the project factory has fully built
  # the project, enabled APIs, and completed Shared VPC attachment bindings!
  depends_on = [
    module.factory
  ]
}
