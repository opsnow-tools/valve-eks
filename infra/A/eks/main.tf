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

module "okc0" {
  source = "./modules/okc0"

  # common value
  region = "ap-northeast-2"
  city = ""
  stage = ""
  name = ""

}

# output
  
output "config" {
  value = module.okc0.config
}
