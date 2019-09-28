variable "cluster_name" {}

variable "vpc_id" {}

variable "private_subnets" {
  type = "list"
}

variable "public_subnets" {
  type = "list"
}

variable "tags" {
  type = "map"
}

variable "max_size" {}

variable "min_size" {}

variable "instance_type" {}

variable "route53_zone_name" {}

data "aws_region" "current" {}
