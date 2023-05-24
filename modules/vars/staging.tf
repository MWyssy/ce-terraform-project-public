locals {
  staging = {

    # VPC vars
    vpc_name = "ce-vpc-staging"
    vpc_cidr = "10.0.0.0/24"

    # Internet Gateway Vars
    ig_name = "staging-ig"

    # Subnet Vars
    subnets = {
      public-1 = {
        az     = "eu-west-2a"
        cidr   = "10.0.0.0/27"
        public = "true"
        name   = "public-1"
      }
      private-1 = {
        az     = "eu-west-2a"
        cidr   = "10.0.1.0/27"
        public = "false"
        name   = "private-1"
      }
    }

    # Nat-Gateway Vars


    #Tags
    user = "Developers"
  }
}
