locals {
  production = {
    # VPC vars
    vpc_name = "ce-vpc-production"
    vpc_cidr = "10.0.0.0/16"

    # Internet Gateway Vars
    ig_name = "production-ig"

    # Subnet Vars
    subnets = {
      public-1 = {
        az     = "eu-west-2a"
        cidr   = "10.0.0.0/24"
        public = "true"
        name   = "public-1"
      }
      private-1 = {
        az     = "eu-west-2a"
        cidr   = "10.0.1.0/24"
        public = "false"
        name   = "private-1"
      }
      public-2 = {
        az     = "eu-west-2b"
        cidr   = "10.0.2.0/24"
        public = "true"
        name   = "public-2"
      }
      private-2 = {
        az     = "eu-west-2b"
        cidr   = "10.0.3.0/24"
        public = "false"
        name   = "private-2"
      }
      public-3 = {
        az     = "eu-west-2c"
        cidr   = "10.0.4.0/24"
        public = "true"
        name   = "public-3"
      }
      private-3 = {
        az     = "eu-west-2c"
        cidr   = "10.0.5.0/24"
        public = "false"
        name   = "private-3"
      }
    }


    # Tags
    user = "Customers"
  }
}
