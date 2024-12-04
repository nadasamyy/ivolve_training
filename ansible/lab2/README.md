Lab 8: Ansible Playbooks for Web Server Configuration
Objective
Write an Ansible playbook to automate the configuration of a web server.

Solution
This playbook installs and configures a web server (Apache) on a target machine. It also ensures the web server is running and creates a sample HTML file for testing.

Prerequisites
Install Ansible on your control machine.
Set up an inventory file with the target machine(s) information.
Ensure you can SSH into the target machine(s) with appropriate privileges.
Ansible Playbook
Below is the playbook file named webserver.yml:

yaml
Copy code
---
- name: Configure a Web Server
  hosts: webservers
  become: true

  tasks:
    - name: Update the system packages
      apt:
        update_cache: yes

    - name: Install Apache Web Server
      apt:
        name: apache2
        state: present

    - name: Ensure Apache is running and enabled
      service:
        name: apache2
        state: started
        enabled: yes

    - name: Create a sample HTML file
      copy:
        dest: /var/www/html/index.html
        content: "<h1>Welcome to Ansible Configured Web Server</h1>"
Steps to Run the Playbook
Clone the Repository:

bash
Copy code
git clone https://github.com/yourusername/your-repo.git
cd your-repo
Set up Inventory:
Create an inventory file with the following content:

ini
Copy code
[webservers]
target_server_ip ansible_user=username ansible_ssh_private_key_file=/path/to/private/key
Replace target_server_ip, username, and /path/to/private/key with your specific details.

Run the Playbook: Execute the following command to run the playbook:

bash
Copy code
ansible-playbook -i inventory webserver.yml
Expected Outcome
Apache web server will be installed on the target machine.
Apache will be running and enabled to start on boot.
A sample HTML page will be created at /var/www/html/index.html.
