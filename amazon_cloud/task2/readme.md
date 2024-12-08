# Lab 13: Launching an EC2 Instance on Amazon Cloud

## Objective
Create a VPC with public and private subnets, launch an EC2 instance in each, configure security for private EC2, and access the private EC2 using the public EC2 as a bastion host.

---

## **Steps**

### **1. Create a VPC**

#### **Login to AWS Console:**
- Navigate to the AWS Management Console and select the **VPC** service.

#### **Create a New VPC:**
1. Go to **Your VPCs** → **Create VPC**.
2. Provide the following details:
   - **Name tag:** `Lab-VPC`
   - **IPv4 CIDR block:** `10.0.0.0/16`
3. Click **Create VPC**.

---

### **2. Create Subnets**

#### **Public Subnet:**
1. Go to **Subnets** → **Create Subnet**.
2. Choose:
   - **VPC ID:** `Lab-VPC`
   - **Subnet Name:** `Public-Subnet`
   - **Availability Zone:** Choose one (e.g., `us-east-1a`)
   - **IPv4 CIDR block:** `10.0.1.0/24`
3. Click **Create Subnet**.

#### **Private Subnet:**
1. Repeat the above steps with:
   - **Subnet Name:** `Private-Subnet`
   - **IPv4 CIDR block:** `10.0.2.0/24`
2. Click **Create Subnet**.

---

### **3. Create an Internet Gateway (IGW)**

#### **Create IGW:**
1. Go to **Internet Gateways** → **Create Internet Gateway**.
2. Name it `Lab-IGW`.
3. Click **Create Internet Gateway**.

#### **Attach IGW to VPC:**
1. Select `Lab-IGW` → **Actions** → **Attach to VPC**.
2. Select `Lab-VPC` and attach.

---

### **4. Configure Route Tables**

#### **Public Route Table:**
1. Go to **Route Tables** and locate the one associated with `Lab-VPC`.
2. Rename it to `Public-Route-Table`.
3. Add a route:
   - **Destination:** `0.0.0.0/0`
   - **Target:** `Lab-IGW`
4. Associate `Public-Subnet` to this route table.

#### **Private Route Table:**
1. Create a new route table.
2. Name it `Private-Route-Table`.
3. Associate `Private-Subnet` to this route table.

---

### **5. Launch EC2 Instances**

#### **Public EC2 Instance:**
1. Go to **EC2** → **Launch Instance**.
2. Configure:
   - **Name:** `Public-Instance`
   - **AMI:** Amazon Linux 2
   - **Instance Type:** `t2.micro`
   - **Network:** `Lab-VPC`
   - **Subnet:** `Public-Subnet`
   - **Auto-assign Public IP:** Enabled
3. Create a security group `Public-SG` allowing:
   - **Inbound:** SSH (port 22) from `0.0.0.0/0`

#### **Private EC2 Instance:**
1. Launch another instance with:
   - **Name:** `Private-Instance`
   - **AMI:** Amazon Linux 2
   - **Instance Type:** `t2.micro`
   - **Network:** `Lab-VPC`
   - **Subnet:** `Private-Subnet`
   - **Auto-assign Public IP:** Disabled
2. Create a security group `Private-SG` allowing:
   - **Inbound:** SSH (port 22) from the **Private IP** of `Public-Instance`

---

### **6. SSH Configuration**

#### **Generate Key Pair:**
1. In **EC2**, create a key pair (e.g., `Lab-KeyPair`) and download the `.pem` file.

#### **SSH to Public Instance:**
1. Open a terminal and use the key pair to connect:
   ```bash
   ssh -i Lab-KeyPair.pem ec2-user@<Public-Instance-Public-IP>
   ```

#### **Access Private Instance via Bastion Host:**
1. Once inside the `Public-Instance`, SSH to the `Private-Instance` using:
   ```bash
   ssh -i Lab-KeyPair.pem ec2-user@<Private-Instance-Private-IP>
   ```

---

### **7. Test the Connectivity**

- Verify you can connect to the **Private Instance** through the **Public EC2 instance**.
- Ensure the **Private EC2 security group** only allows access from the **Public EC2 private IP**.

---

