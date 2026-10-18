# Create a security group for the Public EC2 Instances
resource "aws_security_group" "cie_webserver_sg" {
  name        = "cie_webserver_sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-cie-webserver-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.cie_webserver_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id            = aws_security_group.cie_webserver_sg.id
  referenced_security_group_id = var.alb_sg_id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id            = aws_security_group.cie_webserver_sg.id
  referenced_security_group_id = var.alb_sg_id
  from_port                    = 443
  ip_protocol                  = "tcp"
  to_port                      = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.cie_webserver_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# Create a launch template for the Public EC2 Instances
resource "aws_launch_template" "webserver_lt" {
  name = "webserver_lt"
  #name_prefix = "webserver-lt-"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = filebase64("${path.root}/scripts/cie-app-deployment.sh")

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.cie_webserver_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-webserver-instance"
    })
  }
}

# Create an Auto Scaling Group for the Public EC2 Instances
resource "aws_autoscaling_group" "cie_webserver_asg" {
  name                      = "cie-webservers-asg"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = false
  vpc_zone_identifier       = [var.public_subnet_az_1a_id, var.public_subnet_az_1b_id]

  target_group_arns = [var.cie_webserver_tg_arn]

  launch_template {
    id      = aws_launch_template.webserver_lt.id
    version = "$Latest"
  }
}

