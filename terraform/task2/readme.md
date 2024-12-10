
# **Lab 18: Terraform Modules**

## **Description**
This Terraform project demonstrates the use of modules to create AWS infrastructure. The infrastructure includes a VPC with two public subnets and EC2 instances deployed in each subnet with Nginx installed using user data.

---

## **Objective**
- **Create a VPC** with two public subnets.
- **Develop an EC2 module** that deploys a single EC2 instance with Nginx pre-installed using user data.
- **Deploy two EC2 instances** using the module, one in each public subnet.

---

## **File Structure**
```plaintext
terraform-lab18/
├── main.tf              # Root module for deploying the infrastructure
├── providers.tf         # AWS provider configuration
├── modules/
  ├── ec2/
      ├── main.tf       # EC2 instance configuration with Nginx setup
      ├── variables.tf  # Input variables for the EC2 module
      ├── outputs.tf    # Outputs from the EC2 module
     ├── user_data.sh  # Script to install and start Nginx
```

---

## **Steps to Implement**

### **1. VPC Module**
- Create a VPC with CIDR block `10.0.0.0/16`.
- Create two public subnets:
  - Subnet 1: `10.0.1.0/24` in `us-east-1a`.
  - Subnet 2: `10.0.2.0/24` in `us-east-1b`.

#### **Outputs**:
- `vpc_id`: ID of the created VPC.
- `public_subnet_ids`: IDs of the two public subnets.

### **2. EC2 Module**
- Deploy an EC2 instance with the following configuration:
  - Instance Type: `t2.micro`.
  - User Data: Script to install and enable Nginx.
  - Security Group: Allows HTTP and SSH access.
- Use the EC2 module to deploy one instance in each subnet.

#### **Outputs**:
- `instance_id`: ID of the created EC2 instance.
- `public_ip`: Public IP of the EC2 instance.

### **3. Root Module**
- Call the VPC and EC2 modules in the `main.tf` file.
- Pass the output of the VPC module (`public_subnet_ids`) as input to the EC2 module.

---

## **Commands to Deploy**

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Validate the Configuration**:
   ```bash
   terraform validate
   ```

3. **Apply the Configuration**:
   ```bash
   terraform apply
   ```

4. **Verify Outputs**:
   After successful deployment, Terraform will output the public IP addresses of the EC2 instances. Use them to access Nginx in a browser.

---

## **Example Output**
```plaintext
Outputs:

vpc_id = "vpc-0abcd1234efgh5678"
public_subnet_ids = [
  "subnet-0abcd1234efgh5678",
  "subnet-0ijkl1234mnop5678"
]
ec2_1_public_ip = "54.123.45.67"
ec2_2_public_ip = "54.234.56.78"
```

---

## **Access Nginx**
Use the public IP addresses provided in the outputs to access the Nginx default page in a browser:
- EC2 Instance 1: `http://<ec2_1_public_ip>`
- EC2 Instance 2: `http://<ec2_2_public_ip>`

---

## **Key Features**
- Modularized Terraform structure for reusability and clarity.
- Automated Nginx installation using user data.
- Public IP assignment for direct access to EC2 instances.

---

## **Notes**
- Replace the AMI ID (`ami-0c02fb55956c7d316`) with a valid AMI for your region.
- Ensure you have a valid AWS key pair and specify its name in the `key_name` variable.

---

## **License**
This project is licensed under the MIT License.
