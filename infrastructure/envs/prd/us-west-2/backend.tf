terraform {
  backend "s3" {
    bucket = "ops-rearc"
    key    = "terraform/prd-us-west-2-rearc.tfstate"
    region = "us-east-2"
  }
}
