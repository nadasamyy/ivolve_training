Lab 13: Launching an EC2 Instance on Amazon Cloud
Objective: Create a VPC with public and private subnets, launch an EC2 instance in each, configure security for private EC2, and access the private EC2 using the public EC2 as a bastion host.

Steps:
1. Create a VPC
Login to AWS Console:
Navigate to the AWS Management Console and select the VPC service.

Create a New VPC:

Go to Your VPCs → Create VPC.
Provide:
Name tag: Lab-VPC.
IPv4 CIDR block: 10.0.0.0/16.
Click Create VPC.
2. Create Subnets
Public Subnet:

Go to Subnets → Create Subnet.
Choose:
VPC ID: Lab-VPC.
Subnet Name: Public-Subnet.
Availability Zone: Choose one (e.g., us-east-1a).
IPv4 CIDR block: 10.0.1.0/24.
Click Create Subnet.
Private Subnet:

Repeat the above steps with:
Subnet Name: Private-Subnet.
IPv4 CIDR block: 10.0.2.0/24.
Click Create Subnet.
3. Create an Internet Gateway (IGW)
Create IGW:

Go to Internet Gateways → Create Internet Gateway.
Name it Lab-IGW.
Click Create Internet Gateway.
Attach IGW to VPC:

Select Lab-IGW → Actions → Attach to VPC.
Select Lab-VPC and attach.
4. Configure Route Tables
Public Route Table:

Go to Route Tables and locate the one associated with Lab-VPC.
Rename it to Public-Route-Table.
Add a route:
Destination: 0.0.0.0/0.
Target: Lab-IGW.
Associate Public-Subnet to this route table.
Private Route Table:

Create a new route table.
Name it Private-Route-Table.
Associate Private-Subnet to this route table.
5. Launch EC2 Instances
Public EC2 Instance:

Go to EC2 → Launch Instance.
Configure:
Name: Public-Instance.
AMI: Amazon Linux 2.
Instance Type: t2.micro.
Network: Lab-VPC.
Subnet: Public-Subnet.
Auto-assign Public IP: Enabled.
Create a security group Public-SG allowing:
Inbound: SSH (port 22) from 0.0.0.0/0.
Private EC2 Instance:

Launch another instance with:
Name: Private-Instance.
AMI: Amazon Linux 2.
Instance Type: t2.micro.
Network: Lab-VPC.
Subnet: Private-Subnet.
Auto-assign Public IP: Disabled.
Create a security group Private-SG allowing:
Inbound: SSH (port 22) from Public-Instance's private IP.
6. SSH Configuration
Generate Key Pair:

In EC2, create a key pair (e.g., Lab-KeyPair) and download the .pem file.
SSH to Public Instance:

Open a terminal and use the key pair:
bash
Copy code
ssh -i Lab-KeyPair.pem ec2-user@<Public-Instance-Public-IP>
Access Private Instance via Bastion Host:

Once inside the Public EC2 instance, SSH to the Private Instance using:
bash
Copy code
ssh -i Lab-KeyPair.pem ec2-user@<Private-Instance-Private-IP>
7. Test the Connectivity
Verify you can connect to the Private Instance through the Public EC2 instance.
Ensure the Private EC2 security group only allows access from the Public EC2 private IP.
