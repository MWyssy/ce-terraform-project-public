locals {
  production = {
    # Init
    init = false

    # VPC vars
    vpc_name = "ce-vpc-production"
    vpc_cidr = "10.0.0.0/16"

    # Internet Gateway Vars
    ig_name = "production-ig"

    # Subnet Vars
    subnets = {
      public-1 = {
        az            = "eu-west-2a"
        cidr          = "10.0.0.0/24"
        public        = "true"
        name          = "public-1"
        subnet_number = 1
      }
      private-1 = {
        az            = "eu-west-2a"
        cidr          = "10.0.1.0/24"
        public        = "false"
        name          = "private-1"
        subnet_number = 1
      }
      public-2 = {
        az            = "eu-west-2b"
        cidr          = "10.0.2.0/24"
        public        = "true"
        name          = "public-2"
        subnet_number = 2
      }
      private-2 = {
        az            = "eu-west-2b"
        cidr          = "10.0.3.0/24"
        public        = "false"
        name          = "private-2"
        subnet_number = 2
      }
      public-3 = {
        az            = "eu-west-2c"
        cidr          = "10.0.4.0/24"
        public        = "true"
        name          = "public-3"
        subnet_number = 3
      }
      private-3 = {
        az            = "eu-west-2c"
        cidr          = "10.0.5.0/24"
        public        = "false"
        name          = "private-3"
        subnet_number = 3
      }
    }

    # Nat-Gateway Vars
    nat_name = "production-ng"

    # Route Table Vars
    rt_name = "rt-production"

    # Security Group Vars
    sg_name = "securitygroup-main-production"

    # Target Group Vars
    tg_name = "tg-main-production"

    # Key-Piar Vars
    key_name = "kp-production"

    # Launch Table Vars
    launch_name   = "launch_production"
    instance_type = "t2.micro"

    # Load Balancer Vars
    lb_name = "lb-main-production"

    # Auto-Scaling Vars
    asg_name         = "asg-main-production"
    min_size         = 3
    max_size         = 5
    desired_capacity = 3

    # S3 bucket
    bucket_name = "s3-filestore-production"

    # Tags
    user = "Customers"
  }
}
