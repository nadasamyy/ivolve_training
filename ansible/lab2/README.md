# Automating Web Server Configuration with Ansible

## **Problem Description: Automating Web Server Configuration**

The task is to automate the configuration of a web server using Ansible. Manually setting up a web server on multiple machines can be time-consuming and prone to errors. By writing an Ansible playbook, we can ensure the setup is consistent, efficient, and repeatable. The playbook should handle tasks like:

- Installing the web server
- Configuring it
- Starting the service
- Deploying a test web page

---

## **Solution Description: Automating Web Server Setup with Ansible**

The goal of this lab is to create an Ansible playbook that automates the setup and configuration of a web server. The playbook ensures that the server is installed, configured, and ready to serve web pages with minimal manual effort. Here's how the solution works:

### **Steps to Solve the Problem**

1. **Prepare the Environment**
   - Specify the target servers in an inventory file (IP or hostname).

2. **Write the Playbook**
   - **Hosts**: Define the servers to configure.
   - **Tasks**: List the actions to automate, such as:
     - Updating the system packages.
     - Installing the web server (e.g., Apache or Nginx).
     - Configuring the web server (e.g., copying configuration files).
     - Starting and enabling the web server to run automatically on boot.
     - Deploying a sample HTML page to verify the setup.

3. **Run the Playbook**
   - Use the `ansible-playbook` command to apply the configuration to the servers.

4. **Verify the Setup**
   - Test the web server by accessing the deployed HTML page in a browser or using `curl`.

---

## **Conclusion**

This solution uses Ansible to automate repetitive tasks, ensuring a consistent and quick setup process for the web server. With the playbook, the configuration of the web server can be easily repeated across multiple machines, saving time and reducing errors.
