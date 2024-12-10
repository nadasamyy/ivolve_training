# Define variables
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "instance_types" {
  default = ["t2.micro", "t2.micro"]
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-0453ec754f44f9a4a" # Replace with the appropriate AMI for your region
}

variable "key_name" {
  description = "Key pair for EC2 instances"
  default     = "your-key-pair"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# Create Subnets
resource "aws_subnet" "subnets" {
  count             = length(var.subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[count.index]
  map_public_ip_on_launch = true
}

# Create Security Groups
resource "aws_security_group" "nginx_sg" {
  vpc_id = aws_vpc.main.id

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
}

resource "aws_security_group" "apache_sg" {
  vpc_id = aws_vpc.main.id

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
}

# Create EC2 Instances
resource "aws_instance" "instances" {
  count         = 2
  ami           = var.ami_id
  instance_type = var.instance_types[count.index]
  subnet_id     = aws_subnet.subnets[count.index].id
  key_name      = var.key_name

  security_groups = [
    count.index == 0 ? aws_security_group.nginx_sg.name : aws_security_group.apache_sg.name
  ]

  provisioner "remote-exec" {
    inline = [
      count.index == 0 ? "sudo apt update && sudo apt install -y nginx" : "sudo apt update && sudo apt install -y apache2"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/your-private-key.pem")
      host        = self.public_ip
    }
  }
}

# Manual NAT Gateway Handling
# Create the NAT Gateway manually in AWS Management Console.
# Then import it into Terraform with the following command:
# terraform import aws_nat_gateway.nat_gw <NAT_GATEWAY_ID>

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "" # Fill this after importing
  subnet_id     = aws_subnet.subnets[0].id
}

# Output Public and Private IPs
output "ec2_public_ips" {
  value = aws_instance.instances.*.public_ip
}

output "ec2_private_ips" {
  value = aws_instance.instances.*.private_ip
}
