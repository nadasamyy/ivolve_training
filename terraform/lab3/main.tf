# Main Terraform Configuration

# Backend for Remote State
terraform {
  backend "s3" {
    bucket         = "ivolvo-bucket"
    key            = "terraform/lab19/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

# Provider Configuration
provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Lab19-VPC"
  }
}

# Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Lab19-Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Lab19-Internet-Gateway"
  }
}

# Route Table
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

# Associate Route Table with Subnet
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Security Group
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

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = "ami-0453ec754f44f9a4a" # Replace with your desired AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main.id

  # Replace security_groups with security_group_ids
  security_groups    = [aws_security_group.main.id]

  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Lab19-EC2"
  }
}

# CloudWatch Metric Alarm
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

# SNS Topic
resource "aws_sns_topic" "alerts" {
  name = "Lab19-Alerts"
}

# SNS Topic Subscription
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "nadasamyy62@gmail.com" # Replace with your email
}

# VPC Flow Logs
resource "aws_flow_log" "main" {
  log_destination      = aws_s3_bucket.logs.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id
}

# S3 Bucket for Logs
resource "aws_s3_bucket" "logs" {
  bucket = "lab19-vpc-flow-logs"

  tags = {
    Name = "Lab19-Flow-Logs"
  }
}
