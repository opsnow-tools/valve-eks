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

module "valve" {
  source = "./modules"

  # common value
  region = "ap-northeast-2"
  city = ""
  stage = ""
  name = ""

}

# output

output "efs_id" {
  value = module.valve.efs_id
}
