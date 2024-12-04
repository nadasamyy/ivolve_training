# Ansible Roles for Application Deployment

## **Objective**
The objective of this project is to organize Ansible playbooks using roles. We will create an Ansible role for the following components:
- **Jenkins**
- **Docker**
- **OpenShift CLI (`OC`)**

## **Overview**
Ansible roles allow for the modularization of tasks and configurations in a playbook, making it easier to maintain and reuse. In this project, we will create separate roles for installing and configuring **Jenkins**, **Docker**, and the **OpenShift CLI (`OC`)**, which can be reused in other playbooks or environments.

## **Roles**
Each role will be defined in its own directory with a specific structure to handle tasks, variables, and configurations. The roles will be used to automate the deployment of Jenkins, Docker, and OC CLI on your desired system.

### **1. Jenkins Role**
This role will install and configure **Jenkins**, including:
- Installing the necessary packages and dependencies.
- Configuring the Jenkins service to start on boot.
- Setting up the initial configuration (e.g., plugins, security settings).

#### **Role Directory Structure**
roles/ └── jenkins/ ├── tasks/ │ └── main.yml ├── defaults/ │ └── main.yml ├── vars/ │ └── main.yml └── handlers/ └── main.ym

#### **Key Tasks:**
- Install Jenkins.
- Configure Jenkins service.
- Set up initial plugins.

### **2. Docker Role**
This role will handle the installation of **Docker**, including:
- Installing Docker packages.
- Starting and enabling the Docker service.
- Configuring Docker (if required).

#### **Role Directory Structure**
roles/ └── docker/ ├── tasks/ │ └── main.yml ├── defaults/ │ └── main.yml ├── vars/ │ └── main.yml └── handlers/ └── main.yml

#### **Key Tasks:**
- Install Docker.
- Start and enable Docker service.

### **3. OpenShift CLI (OC) Role**
This role will handle the installation of the **OpenShift CLI (`OC`)**, including:
- Installing the OpenShift CLI tools.
- Configuring the `oc` command to interact with the OpenShift cluster.

#### **Role Directory Structure**
roles/ └── oc-cli/ ├── tasks/ │ └── main.yml ├── defaults/ │ └── main.yml ├── vars/ │ └── main.yml └── handlers/ └── main.yml

#### **Key Tasks:**
- Download and install `oc` CLI.
- Configure `oc` for use with OpenShift.

## **Usage**

### **Running the Playbook**
To use these roles, you need to create a playbook that includes all three roles. Here is an example playbook:

```yaml
---
- name: Deploy Jenkins, Docker, and OC CLI
  hosts: all
  become: true
  roles:
    - jenkins
    - docker
    - oc-cli
### **Running the Playbook**
Execute the playbook using the following command:

bash
Copy code
ansible-playbook -i inventory deploy.yml
Make sure to replace inventory with the path to your inventory file and deploy.yml with the name of your playbook.

Requirements
Ansible 2.x or higher.
Access to the target machines with appropriate privileges.
