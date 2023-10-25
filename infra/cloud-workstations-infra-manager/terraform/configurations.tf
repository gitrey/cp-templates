/**
 * Copyright 2023 Google LLC
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

resource "google_workstations_workstation_config" "workstation_configs" {
  provider = google-beta
  project  = var.project_id
  location = var.region

  for_each = toset(["golang", "java", "python"])

  workstation_config_id  = "workstations-${each.key}-config"
  workstation_cluster_id = google_workstations_workstation_cluster.workstation_cluster.workstation_cluster_id

  idle_timeout    = "1200s"
  running_timeout = "21600s"

  annotations = {
    managed-by = "cloud-workbench"
  }

  host {
    gce_instance {
      machine_type                = "e2-standard-4"
      boot_disk_size_gb           = 35
      disable_public_ip_addresses = false
    }
  }

  container {
    image = "codeoss"
  }
}
