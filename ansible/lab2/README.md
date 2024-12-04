#!/bin/bash

# Step 1: Set up the project directory
PROJECT_NAME="ansible-lab8"
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# Step 2: Create the webserver playbook
cat <<EOL > webserver.yml
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

    - name: Deploy the index.html file
      copy:
        src: index.html
        dest: /var/www/html/index.html
EOL

# Step 3: Create the index.html file
cat <<EOL > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome</title>
</head>
<body>
    <h1>Welcome to the Ansible Configured Web Server!</h1>
    <p>This page was deployed using Ansible.</p>
</body>
</html>
EOL

# Step 4: Create the README.md file
cat <<EOL > README.md
# Lab 8: Ansible Playbooks for Web Server Configuration

## Objective
Automate the configuration of a web server using an Ansible playbook.

## Solution
This project includes:
1. A playbook (\`webserver.yml\`) to configure a web server.
2. A sample \`index.html\` file to be served by the web server.

### Playbook: \`webserver.yml\`
The playbook automates the following tasks:
- Updates system packages.
- Installs and configures the Apache web server.
- Ensures the Apache service is running and enabled at startup.
- Deploys the custom \`index.html\` file to the default web server directory.

### Sample Webpage: \`index.html\`
The \`index.html\` file contains the following content:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome</title>
</head>
<body>
    <h1>Welcome to the Ansible Configured Web Server!</h1>
    <p>This page was deployed using Ansible.</p>
</body>
</html>
```

### Prerequisites
1. Install Ansible on your control machine.
2. Set up an inventory file with your target machine(s).
3. Ensure SSH access to the target machine.

### Running the Playbook
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/$PROJECT_NAME.git
   cd $PROJECT_NAME
   ```

2. Add your target machine(s) to the inventory file:
   ```ini
   [webservers]
   target_server_ip ansible_user=username ansible_ssh_private_key_file=/path/to/private/key
   ```

3. Run the playbook:
   ```bash
   ansible-playbook -i inventory webserver.yml
   ```

### Expected Output
- Apache web server is installed, running, and enabled.
- The \`index.html\` file is served as the default homepage.

EOL
