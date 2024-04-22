resource "aws_vpc" "vpc_tic_tac_toe" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc_ttt"
  }
}

resource "aws_internet_gateway" "igw_tic_tac_toe" {
  vpc_id = aws_vpc.vpc_tic_tac_toe.id

  tags = {
    Name = "igw_ttt"
  }
}

resource "aws_subnet" "subnet_tic_tac_toe" {
  vpc_id     = aws_vpc.vpc_tic_tac_toe.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet_ttt"
  }
}

resource "aws_route_table" "rt_tic_tac_toe" {
  vpc_id = aws_vpc.vpc_tic_tac_toe.id

  tags = {
    Name = "rt_ttt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_tic_tac_toe.id
  }
}

resource "aws_route_table_association" "rta_tic_tac_toe" {
  subnet_id      = aws_subnet.subnet_tic_tac_toe.id
  route_table_id = aws_route_table.rt_tic_tac_toe.id
}

resource "aws_security_group" "sg_tic_tac_toe" {
  name        = "sec_group"
  description = "security group for the EC2 instance"
  ingress = [
    {
      description      = "https traffic"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0", aws_vpc.vpc_tic_tac_toe.cidr_block]
      ipv6_cidr_blocks  = []
      prefix_list_ids   = []
      security_groups   = []
      self              = false
    },
    {
      description      = "http traffic"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0", aws_vpc.vpc_tic_tac_toe.cidr_block]
      ipv6_cidr_blocks  = []
      prefix_list_ids   = []
      security_groups   = []
      self              = false
    },
    {
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0", aws_vpc.vpc_tic_tac_toe.cidr_block]
      ipv6_cidr_blocks  = []
      prefix_list_ids   = []
      security_groups   = []
      self              = false
    },
    {
      description      = "Backend"
      from_port        = 3000
      to_port          = 3000
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0", aws_vpc.vpc_tic_tac_toe.cidr_block]
      ipv6_cidr_blocks  = []
      prefix_list_ids   = []
      security_groups   = []
      self              = false
    },
    {
      description      = "Frontend"
      from_port        = 5173
      to_port          = 5173
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0", aws_vpc.vpc_tic_tac_toe.cidr_block]
      ipv6_cidr_blocks  = []
      prefix_list_ids   = []
      security_groups   = []
      self              = false
    }
  ]
  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Outbound traffic rule"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  tags = {
    name = "allow_web"
  }
}

resource "aws_key_pair" "deployer" {
  key_name = "terraform"
  public_key = "${file("terraform.pub")}"
}

resource "aws_instance" "ec2_tic_tac_toe" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "terraform"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.sg_tic_tac_toe.id]

  tags = {
    Name = "ec2_ttt"
  }

  user_data = "${file("app-installation.sh")}"
}
