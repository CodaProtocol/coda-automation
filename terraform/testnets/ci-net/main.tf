terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    key     = "terraform-ci-net.tfstate"
    encrypt = true
    region  = "us-west-2"
    bucket  = "o1labs-terraform-state"
    acl     = "bucket-owner-full-control"
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "google" {
<<<<<<< HEAD
  alias   = "google-us-east4"
  project = "o1labs-192920"
  region  = "us-east4"
  zone    = "us-east4-b"
=======
  alias   = "google-us-central1"
  project = "o1labs-192920"
  region  = "us-central1"
  zone    = "us-central1-c"
>>>>>>> 90f5a8a... add initial (variable + minimal) testnet setup for ci-net
}

variable "testnet_name" {
  type = string

  description = "Name identifier of testnet to provision"
  default     = "ci-net"
}

variable "coda_image" {
  type = string

  description = "Mina daemon image to use in provisioning a ci-net"
<<<<<<< HEAD
  default     = "gcr.io/o1labs-192920/coda-daemon:0.0.17-beta11-develop"
=======
  default     = "gcr.io/o1labs-192920/coda-daemon-baked:0.0.16-beta7-4.1-turbo-pickles-79f7316-turbo-pickles-a2ec945"
>>>>>>> 90f5a8a... add initial (variable + minimal) testnet setup for ci-net
}

variable "coda_archive_image" {
  type = string

  description = "Mina archive node image to use in provisioning a ci-net"
<<<<<<< HEAD
  default     = "gcr.io/o1labs-192920/coda-archive:0.0.17-beta11-develop"
}

variable "whale_count" {
  type = number

  description = "Number of online whales for the network to run"
  default     = 2
}

variable "fish_count" {
  type = number

  description = "Number of online fish for the network to run"
  default     = 2
}

locals {
  seed_region = "us-east4"
  seed_zone = "us-east4-b"
}

module "ci_testnet" {
  providers = { google = google.google-us-east4 }
  source    = "../../modules/kubernetes/testnet"

  k8s_context = "gke_o1labs-192920_us-east4_coda-infra-east4"

  cluster_name          = "coda-infra-east4"
  cluster_region        = "us-east4"
  testnet_name          = var.testnet_name

  coda_image            = var.coda_image
  coda_archive_image    = var.coda_archive_image
  coda_agent_image      = "codaprotocol/coda-user-agent:0.1.5"
  coda_bots_image       = "codaprotocol/coda-bots:0.0.13-beta-1"
  coda_points_image     = "codaprotocol/coda-points-hack:32b.4"

  whale_count           = var.whale_count
  fish_count            = var.fish_count

  coda_faucet_amount    = "10000000000"
  coda_faucet_fee       = "100000000"

  mina_archive_schema = "https://raw.githubusercontent.com/MinaProtocol/mina/2f36b15d48e956e5242c0abc134f1fa7711398dd/src/app/archive/create_schema.sql"

  additional_seed_peers = []

  seed_port = "10001"

  seed_zone = local.seed_zone
  seed_region = local.seed_region

  log_level              = "Info"
  log_txn_pool_gossip    = false
  log_received_blocks    = true

  block_producer_key_pass = "naughty blue worm"
  block_producer_starting_host_port = 10501

  block_producer_configs = concat(
    [
      for i in range(var.whale_count): {
        name                   = "whale-block-producer-${i + 1}"
        class                  = "whale"
        id                     = i + 1
        private_key_secret     = "online-whale-account-${i + 1}-key"
        enable_gossip_flooding = false
        run_with_user_agent    = false
        run_with_bots          = false
        enable_peer_exchange   = true
        isolated               = false
      }
    ],
    [
      for i in range(var.fish_count): {
        name                   = "fish-block-producer-${i + 1}"
        class                  = "fish"
        id                     = i + 1
        private_key_secret     = "online-fish-account-${i + 1}-key"
        enable_gossip_flooding = false
        run_with_user_agent    = false
        run_with_bots          = false
        enable_peer_exchange   = true
        isolated               = false
      }
    ]
  )

  snark_worker_replicas = 1
  snark_worker_fee      = "0.025"
  snark_worker_public_key = "B62qk4nuKn2U5kb4dnZiUwXeRNtP1LncekdAKddnd1Ze8cWZnjWpmMU"
  snark_worker_host_port = 10401

  agent_min_fee = "0.05"
  agent_max_fee = "0.1"
  agent_min_tx = "0.0015"
  agent_max_tx = "0.0015"
  agent_send_every_mins = "1"
}

output "testnet_genesis_ledger" {
  value = module.ci_testnet.genesis_ledger
}

