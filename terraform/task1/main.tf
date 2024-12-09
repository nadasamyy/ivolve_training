provider "aws" {
  region = "us-east-1" # N. Virginia region
}

# Fetch the VPC where resources will be deployed
data "aws_vpc" "ivolve_vpc" {
  filter {
    name   = "tag:Name"
    values = ["ivolve"]
  }
}

# Public Subnet in us-east-1a
resource "aws_subnet" "public_subnet" {
  vpc_id            = data.aws_vpc.ivolve_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

# Private Subnet in us-east-1b
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = data.aws_vpc.ivolve_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "PrivateSubnetA"
  }
}

# Private Subnet in us-east-1c
resource "aws_subnet" "private_subnet_b" {
  vpc_id            = data.aws_vpc.ivolve_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "PrivateSubnetB"
  }
}

# Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  vpc_id = data.aws_vpc.ivolve_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2SecurityGroup"
  }
}

# Security Group for RDS (MySQL)
resource "aws_security_group" "rds_sg" {
  vpc_id = data.aws_vpc.ivolve_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"] # Allow traffic from public subnet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDSSecurityGroup"
  }
}

# EC2 Instance in Public Subnet
resource "aws_instance" "app" {
  ami           = "ami-0453ec754f44f9a4a" # Amazon Linux 2 AMI ID in us-east-1
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = ["sg-0876c6a2dec3abdf8"] # Use security group ID

  tags = {
    Name = "AppServer"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ec2-ip.txt"
  }
}

# RDS MySQL Database
resource "aws_db_instance" "db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "adminnn"
  password             = "Admin1234"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  tags = {
    Name = "MyDatabase"
  }
}

# RDS Subnet Group (Ensure it spans at least 2 AZs)
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_a.id, # Subnet in AZ us-east-1b
    aws_subnet.private_subnet_b.id  # Subnet in AZ us-east-1c
  ]

  tags = {
    Name = "DBSubnetGroup"
  }
}