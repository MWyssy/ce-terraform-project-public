locals {
  staging = {
    # Init
    init = false

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
        cidr   = "10.0.0.32/27"
        public = "false"
        name   = "private-1"
      }
      public-2 = {
        az     = "eu-west-2b"
        cidr   = "10.0.0.64/27"
        public = "true"
        name   = "public-2"
      }
      private-2 = {
        az     = "eu-west-2b"
        cidr   = "10.0.0.96/27"
        public = "false"
        name   = "private-2"
      }
    }

    # Nat-Gateway Vars
    nat_name = "staging-ng"

    # Route Table Vars
    rt_name = "rt-staging"

    # Security Group Vars
    sg_name = "securitygroup-main-staging"

    # Target Group Vars
    tg_name = "tg-main-staging"

    # Key-Piar Vars
    key_name = "kp-staging"

    # Launch Table Vars
    launch_name   = "launch-staging"
    instance_type = "t2.micro"

    # Load Balancer Vars
    lb_name = "lb-main-staging"

    # Auto-Scaling Vars
    asg_name         = "asg-main-staging"
    min_size         = 1
    max_size         = 1
    desired_capacity = 1

    #Tags
    user = "Developers"
  }
}
