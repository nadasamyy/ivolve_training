# Ansible Dynamic Inventories

## **Objective**
The objective of this project is to set up **Ansible Dynamic Inventories** to automatically discover and manage infrastructure. Additionally, we will use an **Ansible Galaxy role** to install **Apache** on the infrastructure.

## **Overview**
Ansible Dynamic Inventories enable the automation of infrastructure management by dynamically generating the list of hosts based on the environment. Instead of maintaining static inventory files, dynamic inventories allow Ansible to discover and manage infrastructure resources automatically, making it ideal for cloud environments.

In this project, we will:
- Set up a dynamic inventory to discover infrastructure.
- Use an Ansible Galaxy role to install and configure **Apache HTTP Server** on the discovered hosts.

## **Dynamic Inventory Setup**

### **1. Cloud Provider Configuration (Example: AWS)**
Dynamic inventories can be used with different cloud providers. In this example, we'll use **AWS** as the cloud provider. For AWS, Ansible provides a built-in dynamic inventory script.

#### **Requirements:**
- **boto3** and **botocore** Python packages for AWS interaction.
- An AWS account with appropriate IAM permissions to describe instances.

#### **Steps:**
1. **Install AWS dependencies**:
   You need to install `boto3` and `botocore` to allow Ansible to interact with AWS.

   ```bash
   pip install boto3 botocore
