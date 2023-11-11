# REDIS CLUSTER VARIABLES

variable "cluster_id" {
  description = "Replication group identifier."
  default = "redis-cluster"
}

variable "node_type" {
  description = "Instance class to be used."
  default     = "cache.t2.micro"
}

variable "port" {
  description = "Port number on which each of the cache nodes will accept connections."
  default = 6379
}

variable "node_groups" {
  description = "Number of node groups (shards) for this Redis replication group."
  default     = 3
}

variable "automatic_failover_enabled" {
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails."
  default = true
}


# SSH HOST VARIABLES

variable "public_key_path" {
  description = "Path to public key for ssh access."
  default     = "~/.ssh/id_rsa.pub"
}

variable "ami_override" {
  description = "Override the AMI for the SSH host."
  default = null
}

variable "instance_type" {
  description = "Instance type to use for the instance."
  default = "t2.nano"
}

variable "monitoring_enabled" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled."
  default = false
}


# NETWORK VARIABLES

variable "vpc_cidr_block" {
  description = "The IPv4 CIDR block for the VPC."
  default     = "10.1.0.0/16"
}

variable "cidr_blocks" {
  description = "The CIDR blocks for creating subnets."
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}


# GLOBAL VARIABLES

variable "additional_tags" {
  description = "Define additional tags to be added to the resources."
  default = {
    Provisioner = "Terraform"
  }
}