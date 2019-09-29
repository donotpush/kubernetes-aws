variable "cluster_name"{}
variable "vpc_id"{}
variable "private_subnets"{type = list(string)}
variable "public_subnets"{type = list(string)}
variable "min_size"{}
variable "max_size"{}
variable "region"{}
variable "instance_type"{}
variable "route53_zone_name"{}
variable "tags"{type = map(string)}