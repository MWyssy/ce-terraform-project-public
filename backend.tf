terraform {
  backend "s3" {
    bucket         = "ce-tf-remote-store"
    key            = "terraform.tfstate"
    dynamodb_table = "remote-lock"
    region         = "eu-west-2"
  }
}
