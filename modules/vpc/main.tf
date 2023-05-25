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

  for_each = var.private_subs

  tags = {
    UsedBy    = var.user
    ManagedBy = "Terraform"
  }
}

# Create Nat-Gateways
resource "aws_nat_gateway" "nat-gw" {
  for_each      = var.private_subs
  allocation_id = aws_eip.eips["${each.value["name"]}"].id

  subnet_id = aws_subnet.subnets[
    values({
      for k, subnet in aws_subnet.subnets :
      k => subnet.tags["Name"]
      if subnet.availability_zone == each.value["az"]
    && subnet.map_public_ip_on_launch == true })[0]
  ].id

  tags = {
    Name      = "${var.nat_name}-${each.key}"
    UsedBy    = var.user
    ManagedBy = "Terraform"
    Number    = 1
  }

}

# Create Main Route Table
resource "aws_route_table" "rt-main" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name      = "${var.rt_name}-main"
    UsedBy    = var.user
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table_association" "rt-association-main" {
  depends_on = [aws_route_table.rt-main, aws_subnet.subnets]

  count = length(var.public_subs)

  subnet_id      = aws_subnet.subnets["public-${count.index + 1}"].id
  route_table_id = aws_route_table.rt-main.id
}

# Create Private Route Tables
resource "aws_route_table" "rt-private" {
  depends_on = [aws_nat_gateway.nat-gw, aws_subnet.subnets]
  vpc_id     = aws_vpc.vpc.id

  for_each = aws_nat_gateway.nat-gw

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = each.value["id"]
  }

  tags = {
    Name      = "${var.rt_name}-private-${each.value["tags"]["Number"]}"
    UsedBy    = var.user
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table_association" "rt-association-private" {
  depends_on = [aws_route_table.rt-private, aws_subnet.subnets]

  count = length(aws_route_table.rt-private)

  subnet_id      = aws_subnet.subnets["private-${count.index + 1}"].id
  route_table_id = aws_route_table.rt-private["private-${count.index + 1}"].id
}

resource "aws_security_group" "sg-main" {
  name        = var.sg_name
  description = "Allow inbound and outbound internet traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.external.my_ip.result.MY_IP}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.sg_name}"
    UsedBy    = var.user
    ManagedBy = "Terraform"
  }
}
