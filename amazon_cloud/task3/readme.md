
# Lab 14: Create AWS Load Balancer

## Objective
Create a VPC with 2 public subnets, launch 2 EC2 instances with Nginx and Apache installed using user data, and configure a Load Balancer to access the 2 Web servers.

---

## **1. Create a VPC**
1. Log in to your **AWS Management Console**.
2. Go to the **VPC Dashboard**.
3. Click on **Create VPC**.
   - **Name tag**: `Lab14-VPC`
   - **IPv4 CIDR block**: `10.0.0.0/16`
   - Leave other settings as default.
4. Click **Create VPC**.

---

## **2. Create Two Public Subnets**
1. Navigate to **Subnets** in the **VPC Dashboard**.
2. Click **Create subnet**.
3. Configure the first subnet:
   - **Name tag**: `Public-Subnet-1`
   - **VPC**: Select `Lab14-VPC`.
   - **Availability Zone**: Choose any (e.g., `us-east-1a`).
   - **IPv4 CIDR block**: `10.0.1.0/24`.
   - Click **Create subnet**.
4. Configure the second subnet:
   - **Name tag**: `Public-Subnet-2`
   - **VPC**: Select `Lab14-VPC`.
   - **Availability Zone**: Choose a different one (e.g., `us-east-1b`).
   - **IPv4 CIDR block**: `10.0.2.0/24`.
   - Click **Create subnet**.

---

## **3. Enable Auto-Assign Public IP**
1. Select each subnet (`Public-Subnet-1` and `Public-Subnet-2`).
2. Click **Edit subnet settings** and enable **Auto-assign public IPv4 address**.

---

## **4. Create an Internet Gateway and Attach It**
1. Go to **Internet Gateways** in the **VPC Dashboard**.
2. Click **Create internet gateway**.
   - **Name tag**: `Lab14-IGW`
   - Click **Create**.
3. Select the created Internet Gateway and click **Actions > Attach to VPC**.
4. Select `Lab14-VPC` and click **Attach internet gateway**.

---

## **5. Configure a Route Table**
1. Go to **Route Tables** in the **VPC Dashboard**.
2. Click **Create route table**.
   - **Name tag**: `Lab14-RouteTable`
   - **VPC**: Select `Lab14-VPC`.
   - Click **Create**.
3. Select the created route table and click **Edit routes**.
   - Add a route:
     - **Destination**: `0.0.0.0/0`.
     - **Target**: Select `Lab14-IGW`.
   - Click **Save routes**.
4. Associate this route table with the public subnets:
   - Go to **Subnet associations** and click **Edit subnet associations**.
   - Select both `Public-Subnet-1` and `Public-Subnet-2`.
   - Click **Save associations**.

---

## **6. Launch EC2 Instances with User Data**
1. Go to the **EC2 Dashboard** and click **Launch Instances**.
2. Configure the first instance:
   - **Name**: `WebServer-Nginx`.
   - **AMI**: Amazon Linux 2.
   - **Instance type**: t2.micro.
   - **Key pair**: Select an existing key pair or create a new one.
   - **Network settings**:
     - **VPC**: `Lab14-VPC`.
     - **Subnet**: `Public-Subnet-1`.
   - **Advanced details**: Paste the following in **User data** to install Nginx:
     ```bash
     #!/bin/bash
     yum update -y
     amazon-linux-extras enable nginx1
     yum install nginx -y
     systemctl start nginx
     systemctl enable nginx
     echo "<h1>Welcome to Nginx on EC2 - Instance 1</h1>" > /usr/share/nginx/html/index.html
     ```
3. Configure the second instance:
   - **Name**: `WebServer-Apache`.
   - **AMI**: Amazon Linux 2.
   - **Instance type**: t2.micro.
   - **Key pair**: Select the same key pair as above.
   - **Network settings**:
     - **VPC**: `Lab14-VPC`.
     - **Subnet**: `Public-Subnet-2`.
   - **Advanced details**: Paste the following in **User data** to install Apache:
     ```bash
     #!/bin/bash
     yum update -y
     yum install httpd -y
     systemctl start httpd
     systemctl enable httpd
     echo "<h1>Welcome to Apache on EC2 - Instance 2</h1>" > /var/www/html/index.html
     ```

---

## **7. Create a Security Group**
1. Go to **Security Groups** in the **VPC Dashboard**.
2. Click **Create security group**.
   - **Name**: `Lab14-SG`.
   - **VPC**: Select `Lab14-VPC`.
   - Add inbound rules:
     - **Type**: HTTP, **Port**: 80, **Source**: Anywhere (`0.0.0.0/0`).
     - **Type**: SSH, **Port**: 22, **Source**: My IP.
   - Click **Create**.
3. Assign this security group to both EC2 instances.

---

## **8. Create and Configure a Load Balancer**
1. Go to the **EC2 Dashboard** and navigate to **Load Balancers**.
2. Click **Create Load Balancer** and select **Application Load Balancer**.
   - **Name**: `Lab14-ALB`.
   - **Scheme**: Internet-facing.
   - **IP address type**: IPv4.
   - **Listeners**: HTTP (Port 80).
   - **Availability Zones**: Select `Lab14-VPC` and both public subnets.
3. Configure the Target Group:
   - **Target group name**: `Lab14-TG`.
   - **Target type**: Instances.
   - **Protocol**: HTTP.
   - Click **Next** and register the two EC2 instances (`WebServer-Nginx` and `WebServer-Apache`) as targets.
   - Click **Create target group**.
4. Link the Load Balancer to the Target Group:
   - Under **Listeners**, click **Add action** and select **Forward to Lab14-TG**.
   - Click **Create Load Balancer**.

---

## **9. Test the Load Balancer**
1. Once the Load Balancer is active, copy its **DNS name**.
2. Open the DNS name in a browser. You should see traffic alternating between the two web servers:
   - **Instance 1**: Welcome to Nginx.
   - **Instance 2**: Welcome to Apache.

---

## **10. Clean Up (Optional)**
If you want to avoid incurring charges, terminate the EC2 instances, delete the Load Balancer, and delete the VPC and related resources.
