# **README: AWS Infrastructure Setup using Terraform**

This document outlines the steps and resources provisioned for setting up an AWS infrastructure using Terraform. The setup includes VPC configuration, subnets, security groups, an EC2 instance, and an RDS MySQL database.

---

## **Provider Configuration**

The provider is configured to use the AWS region `us-east-1` (N. Virginia region):
```hcl
provider "aws" {
  region = "us-east-1"
}
```

---

## **Fetching the VPC**

The VPC where the resources will be deployed is fetched using the `aws_vpc` data source. The VPC is identified by the tag `Name=ivolve`:
```hcl
data "aws_vpc" "ivolve_vpc" {
  filter {
    name   = "tag:Name"
    values = ["ivolve"]
  }
}
```

---

## **Subnets**

### **Public Subnet**
A public subnet is created in the availability zone `us-east-1a`:
```hcl
resource "aws_subnet" "public_subnet" {
  vpc_id            = data.aws_vpc.ivolve_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}
```

### **Private Subnets**
Two private subnets are created in different availability zones (`us-east-1b` and `us-east-1c`) for redundancy:

**Private Subnet A:**
```hcl
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = data.aws_vpc.ivolve_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "PrivateSubnetA"
  }
}
```

**Private Subnet B:**
```hcl
resource "aws_subnet" "private_subnet_b" {
  vpc_id            = data.aws_vpc.ivolve_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "PrivateSubnetB"
  }
}
```

---

## **Security Groups**

### **EC2 Security Group**
Allows SSH (port 22) access from any IP address:
```hcl
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
```

### **RDS Security Group**
Allows MySQL traffic (port 3306) from the public subnet:
```hcl
resource "aws_security_group" "rds_sg" {
  vpc_id = data.aws_vpc.ivolve_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
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
```

---

## **EC2 Instance**

An EC2 instance is deployed in the public subnet with the `t2.micro` instance type. The public IP address is saved to a local file:
```hcl
resource "aws_instance" "app" {
  ami           = "ami-0453ec754f44f9a4a" # Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "AppServer"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ec2-ip.txt"
  }
}
```

---

## **RDS MySQL Database**

An RDS MySQL instance is deployed with the following configuration:
- Engine: MySQL 8.0
- Instance class: `db.t3.micro`
- Allocated storage: 20 GB

```hcl
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
```

### **RDS Subnet Group**
Ensures the database spans at least two availability zones:
```hcl
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]

  tags = {
    Name = "DBSubnetGroup"
  }
}
```

---

## **Summary**
This Terraform configuration provisions:
- A VPC and subnets (1 public, 2 private)
- Security groups for EC2 and RDS
- An EC2 instance in the public subnet
- An RDS MySQL database in private subnets

This setup ensures a basic infrastructure that is both scalable and secure.


