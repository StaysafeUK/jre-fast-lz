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

# Native HCL Import blocks to cleanly adopt existing partially-created projects
# back into the Terraform state, resolving 409 Requested entity already exists errors.

import {
  id = "placard-prod-net-core-0"
  to = module.projects.module.projects["net-core-0"].google_project.project[0]
}

import {
  id = "placard-dev-net-spoke-0"
  to = module.projects.module.projects["net-dev-0"].google_project.project[0]
}

import {
  id = "placard-prod-net-prod-0"
  to = module.projects.module.projects["net-prod-0"].google_project.project[0]
}
