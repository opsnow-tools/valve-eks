# main

terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = ""
    key    = "" #okc0-efs.tfstate
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "okc0" {
  source = "./modules/okc0"

  # common value
  region = "ap-northeast-2"
  city = ""
  stage = ""
  name = ""

}

# output
output "vpc_id" {
  value = module.okc0.vpc_id
}

output "vpc_cidr" {
  value = module.okc0.vpc_cidr
}
  
output "config" {
  value = module.okc0.efs_id
}
