# VPC Vars
variable "vpc_name" {
  description = "Name of the main VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR range of the VPC"
  type        = string
}

# Internet Gateway Vars
variable "ig_name" {
  description = "Name of the internet gateway"
  type        = string
}

# Subnet Vars
variable "subnets" {
  description = "Map of the subnets to create."
  type        = map(any)
}


# Nat-Gateway Vars
variable "private_subs" {
  description = "Map of the private subnets created"
  type        = map(any)
}

variable "nat_name" {
  description = "Name of each Nat Gateway"
  type        = string
}

# Route Table Vars
variable "rt_name" {
  description = "Name of the route tables"
  type        = string
}
variable "public_subs" {
  description = "Map of the public subnets created"
  type        = map(any)
}

# Security Group Vars
variable "sg_name" {
  description = "Name of the Security Group"
  type        = string
}

# Tags
variable "user" {
  description = "User based on workspace"
  type        = string
}
