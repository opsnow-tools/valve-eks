# main

terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = ""
    key    = "" # .tfstate
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "valve" {
  source = "./modules"
}

# output
  
output "config" {
  value = module.valve.config
}
