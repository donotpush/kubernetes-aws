module "cluster" {
  source = "./src"
  cluster_name = var.cluster_name
  vpc_id = var.vpc_id
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
  min_size = var.min_size
  max_size = var.max_size
  instance_type = var.instance_type
  route53_zone_name = var.route53_zone_name
  tags = var.tags
}

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