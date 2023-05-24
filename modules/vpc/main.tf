# Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name      = var.vpc_name
    UsedBy    = var.user
    ManagedBy = "Terraform"
  }
}

# Create Internet-Gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = var.ig_name
    UsedBy    = var.user
    ManagedBy = "Terraform"
  }
}

# Create the Subnets
resource "aws_subnet" "subnets" {
  for_each = var.subnets

  depends_on = [aws_internet_gateway.ig]

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.value["az"]
  cidr_block              = each.value["cidr"]
  map_public_ip_on_launch = each.value["public"]

  tags = {
    Name      = each.value["name"]
    UsedBy    = var.user
    ManagedBy = "Terraform"
  }
}

# Create Elastic IPs
resource "aws_eip" "eips" {

  depends_on = [aws_internet_gateway.ig]
}

# Create Nat-Gateways
resource "aws_nat_gateway" "nat-gw" {
  for_each = var.private_subs

  # Find name of public subnet in the same az

  pub_name = values({ for k, v in aws_subnet.subnets : k => v.tags["Name"] if v.availability_zone == each.value["az"] && v.map_public_ip_on_launch == true })[0]

  subnet_id = aws_subnet.subnets[var.pub_name].id


  allocation_id = aws_eip.eips.id
}

# Create Route Tables
