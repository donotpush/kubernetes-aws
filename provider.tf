# Uses default configure set by awscli
provider "aws" {
  region = var.region
}

provider "template" {}

# If you want to store your state file in s3 check this out: https://www.terraform.io/docs/backends/types/s3.html
# terraform {
# 	backend "s3" {
# 		encrypt        = true
# 		bucket         = ""
# 		dynamodb_table = ""
# 		region         = ""
# 		key            = ""
# 	}
# }
