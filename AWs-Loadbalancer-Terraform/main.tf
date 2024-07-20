
#creating vpc for Ec2 Instance 
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}
#If We are going to create Public subnet, so it Internet gateway is required.
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.internet_gw_name
  }
}
#creating public subnet
resource "aws_subnet" "rds-s1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet1.cidr_block
  availability_zone = var.subnet1.availability_zone
  map_public_ip_on_launch=true
  tags = {
    Name = var.subnet1.name
   
  }
}
# creating route table for to route subnets traffic to internet gateway
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  } 
 route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
 }
  tags = {
    Name = var.rt1_name
  }
}
# Assciating the route table to the public subnet
resource "aws_route_table_association" "rt_public_subnet1_ass" {
  subnet_id      = aws_subnet.rds-s1.id
  route_table_id = aws_route_table.public_subnet_rt.id
}
// To Generate Private Key
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Create Key Pair for Connecting EC2 via SSH
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

// Save PEM file locally
resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
}

# Create a security group
resource "aws_security_group" "sg_ec2" {
  name        = "sg_ec2"
  description = "Security group for EC2"
   vpc_id      = aws_vpc.main.id

   ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}

#Creating EC2-Instance
resource "aws_instance" "public_instance" {
  count = length(var.ec2_name)
  ami                    = "ami-0f511dde9605eb0b6"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]
 subnet_id     = aws_subnet.rds-s1.id
 user_data    =  file("userdata.tpl")
 user_data_replace_on_change = true
  tags = {
    Name = var.ec2_name[count.index]
  }

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}

#Creating Network Loadbalancer
resource "aws_lb" "nlb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.rds-s1.id]

  enable_deletion_protection = true

}

#Creating Target Group
resource "aws_lb_target_group" "nlb-tg" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
}

#Adding the 2ec2 instances into Target group
resource "aws_lb_target_group_attachment" "tg-attach" {
  count = length(var.ec2_name)
  target_group_arn = aws_lb_target_group.nlb-tg.arn
  target_id        = aws_instance.public_instance[count.index].id
  port             = 80
}

#Creating listener for Loadbalacer to redirect traffic to taregt group
resource "aws_lb_listener" "my_alb_listener" {
 load_balancer_arn = aws_lb.nlb.arn
 port              = "80"
 protocol          = "TCP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.nlb-tg.arn
 }
}

