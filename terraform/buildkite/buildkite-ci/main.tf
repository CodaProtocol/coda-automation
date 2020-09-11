terraform {
  required_version = ">= 0.12.6"
  backend "s3" {
    key     = "terraform-bk-coda-ci.tfstate"
    encrypt = true
    region  = "us-west-2"
    bucket  = "o1labs-terraform-state"
    acl     = "bucket-owner-full-control"
  }
}

# Main variables

locals {
  project_namespace = "buildkite-ci"
}

#
# OPTIONAL: input variables -- recommended to express as environment vars (e.g. TF_VAR_***)
#

variable "google_credentials" {
  type = string

  description = "Custom operator Google Cloud Platform access credentials"
  default     = ""
}

variable "agent_vcs_privkey" {
  type = string

  description = "Version control private key for secured repository access"
  default     = ""
}

variable "k8s_monitoring_ctx" {
  type = string

  description = "Kubernetes provider context for monitoring resources"
  default     = "gke_o1labs-192920_us-east1_buildkite-infra-east1"
}
