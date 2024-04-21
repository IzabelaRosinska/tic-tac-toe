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

resource "aws_subnet" "subnet_tf" {
  vpc_id     = aws_vpc.vpc_tic_tac_toe.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "subnet_ttt"
  }
}

resource "aws_route_table" "rt_tic_tac_toe" {
  vpc_id = aws_vpc.vpc_tic_tac_toe.id

  tags = {
    Name = "rt_ttt"
  }
}

resource "aws_route" "tr_tic_tac_toe" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id  = aws_internet_gateway.igw_tic_tac_toe.id
  route_table_id = aws_route_table.rt_tic_tac_toe.id
}

resource "aws_route_table_association" "rta_tic_tac_toe" {
  subnet_id      = aws_subnet.subnet_tic_tac_toe.id
  route_table_id = aws_route_table.rt_tic_tac_toe.id
}

resource "aws_security_group" "sg_tic_tac_toe" {
  name        = "sec_group"
  description = "security group for the EC2 instance"
  vpc_id      = aws_vpc.vpc_tic_tac_toe.id
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

resource "aws_network_interface" "ni_tic_tac_toe" {
  subnet_id = aws_subnet.subnet_tic_tac_toe.id
  security_groups = [aws_security_group.sg_tic_tac_toe.id]
}

resource "aws_eip" "eip_tic_tac_toe" {
  vpc = true
  network_interface = aws_network_interface.ni_tic_tac_toe.id
  associate_with_private_ip = aws_network_interface.ni_tic_tac_toe.private_ip
  depends_on = [aws_internet_gateway.igw_tic_tac_toe, aws_instance.ec2_tic_tac_toe]
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
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "ec2_ttt"
  }

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.eni_tf.id
  }

  user_data = "${file("app-installation.sh")}"
}
