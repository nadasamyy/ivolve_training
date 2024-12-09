# **Terraform Configuration for Lab19: Remote Backend and Lifecycle Rules**

This repository contains the Terraform code for deploying resources as per Lab19 requirements. The configuration includes setting up a remote backend, creating necessary AWS infrastructure, monitoring EC2 instances, and setting up notifications for high CPU utilization.

---

## **Table of Contents**

1. [Backend Configuration](#backend-configuration)
2. [Provider Configuration](#provider-configuration)
3. [VPC Configuration](#vpc-configuration)
4. [Subnet Configuration](#subnet-configuration)
5. [Internet Gateway](#internet-gateway)
6. [Route Table and Association](#route-table-and-association)
7. [Security Group](#security-group)
8. [EC2 Instance](#ec2-instance)
9. [CloudWatch Metric Alarm](#cloudwatch-metric-alarm)
10. [SNS Topic and Subscription](#sns-topic-and-subscription)
11. [VPC Flow Logs](#vpc-flow-logs)
12. [S3 Bucket for Logs](#s3-bucket-for-logs)

---

## **Backend Configuration**

The remote backend configuration stores the Terraform state file in an S3 bucket for collaboration and versioning.

```hcl
terraform {
  backend "s3" {
    bucket         = "ivolvo-bucket"
    key            = "terraform/lab19/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
```

---

## **Provider Configuration**

Defines the AWS provider and region.

```hcl
provider "aws" {
  region = "us-east-1"
}
```

---

## **VPC Configuration**

Creates a Virtual Private Cloud (VPC).

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Lab19-VPC"
  }
}
```

---

## **Subnet Configuration**

Creates a subnet in the VPC.

```hcl
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Lab19-Subnet"
  }
}
```

---

## **Internet Gateway**

Creates an Internet Gateway for the VPC.

```hcl
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Lab19-Internet-Gateway"
  }
}
```

---

## **Route Table and Association**

Creates a route table and associates it with the subnet.

```hcl
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Lab19-Route-Table"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}
```

---

## **Security Group**

Defines a security group to allow HTTP traffic.

```hcl
resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id
  name   = "Lab19-Security-Group"

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "Lab19-Security-Group"
  }
}
```

---

## **EC2 Instance**

Creates an EC2 instance with public IP and lifecycle rules.

```hcl
resource "aws_instance" "web" {
  ami                    = "ami-0453ec754f44f9a4a" # Replace with your desired AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main.id
  security_group_ids     = [aws_security_group.main.id]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Lab19-EC2"
  }
}
```

---

## **CloudWatch Metric Alarm**

Sets up a CloudWatch alarm to monitor EC2 CPU utilization.

```hcl
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "HighCPUAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = aws_instance.web.id
  }
}
```

---

## **SNS Topic and Subscription**

Creates an SNS topic and sends email alerts for high CPU usage.

```hcl
resource "aws_sns_topic" "alerts" {
  name = "Lab19-Alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "nadasamyy62@gmail.com" # Replace with your email
}
```

---

## **VPC Flow Logs**

Enables flow logs to capture traffic for the VPC.

```hcl
resource "aws_flow_log" "main" {
  log_destination      = aws_s3_bucket.logs.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id
}
```

---

## **S3 Bucket for Logs**

Creates an S3 bucket for storing VPC flow logs.

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "lab19-vpc-flow-logs"

  tags = {
    Name = "Lab19-Flow-Logs"
  }
}
```

