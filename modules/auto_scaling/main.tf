# Create Target Group
resource "aws_lb_target_group" "tg_main" {
  name        = var.tg_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    protocol = "HTTP"
    path     = "/health-check"
  }
}

# Create Key-Pair
resource "aws_key_pair" "default_keypair" {
  key_name   = var.key_name
  public_key = file(var.public_key)
  tags = {
    Name      = var.key_name
    UsedBy    = var.user
    ManagedBy = "Terraform"
  }
}

# Create Launch Template
resource "aws_launch_template" "launch_template" {

  name = var.launch_name

  image_id      = var.ami_id
  instance_type = var.instance_type
  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.sg_id]
  }
  key_name = aws_key_pair.default_keypair.id
  user_data = base64encode(<<EOF
#! /bin/bash
sudo apt update
sudo apt install awscli -y
sudo apt-get update
sudo apt-get install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo rm /etc/nginx/sites-enabled/default
sudo rm /usr/share/nginx/html/index.html
sudo rm /etc/nginx/nginx.conf
sudo aws s3 sync s3://${var.filestore_name} /usr/share/nginx/html
sudo mv /usr/share/nginx/html/nginx.conf /etc/nginx/nginx.conf
sudo systemctl restart nginx.service
  EOF
  )

  update_default_version = true

  iam_instance_profile {
    name = "S3RoleForEC2"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name      = var.launch_name
      UsedBy    = var.user
      ManagedBy = "Terraform"
    }
  }
}

# Create Load Balancer
resource "aws_lb" "lb_main" {
  name               = var.lb_name
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = [for id in var.public_subnet_ids : id]
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb_main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_main.arn
  }
}

# Create Auto-Scaling group
resource "aws_autoscaling_group" "asg_main" {
  name = var.asg_name

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = [for id in var.public_subnet_ids : id]
  target_group_arns   = [aws_lb_target_group.tg_main.arn]
  default_cooldown    = 300
}

