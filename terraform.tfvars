  cluster_name = "my-first-cluster"
  vpc_id = "vpc-XXXX"
  private_subnets = ["subnet-XXXX","subnet-XXXX","subnet-XXXX"]
  public_subnets = ["subnet-XXXX","subnet-XXXX","subnet-XXXX"]
  min_size = 1
  max_size = 2
  instance_type = "m4.large"
  route53_zone_name = "example.io"
  region = "eu-west-1"
  tags = {
      Environment = "dev"
      Project = "K"
      Team = "X"
  }