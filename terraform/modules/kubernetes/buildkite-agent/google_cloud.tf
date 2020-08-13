locals {
  k8s_context = "minikube"
  gke_project = "o1labs-192920"
  gcs_artifact_bucket = "buildkite_k8s"
}

resource "google_service_account" "gcp_buildkite_account" {
  count = var.enable_gcs_access ? 1 : 0

  account_id   = var.cluster_name
  display_name = "Buildkite Agent Cluster (${var.cluster_name}) service account"
  description  = "GCS service account for Buildkite cluster ${var.cluster_name}"
  project      = local.gke_project
}

resource "google_project_iam_member" "buildkite_stackdriver_viewer" {
  project = local.gke_project
  role    = "roles/stackdriver.accounts.viewer"
  member  = "serviceAccount:${google_service_account.gcp_buildkite_account[0].email}"
}

resource "google_project_iam_member" "buildkite_container_developer" {
  project = local.gke_project
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.gcp_buildkite_account[0].email}"
}

resource "google_storage_bucket_iam_binding" "buildkite_gcs_binding" {
  count = var.enable_gcs_access ? 1 : 0

  bucket =local.gcs_artifact_bucket
  role = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.gcp_buildkite_account[0].email}",
  ]
}

resource "google_service_account_key" "buildkite_svc_key" {
  count = var.enable_gcs_access ? 1 : 0

  service_account_id = google_service_account.gcp_buildkite_account[0].name
}
