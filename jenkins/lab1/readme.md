# **Lab 22: Jenkins Installation**

## **Objective**

Install Jenkins and configure it as a service. In this lab, we will go through the steps to install Jenkins and set it up to run as a background service on your system.

---

## **1. Prerequisites**

Before starting the Jenkins installation, ensure you have the following:

- A system running **Ubuntu**, **Debian**, or any compatible Linux distribution.
- **Root** access or **sudo** privileges.
- **Java 8** or newer installed (Jenkins requires Java to run).
  
To verify your Java version, run:
```bash
java -version
2.2 Install Java
Jenkins requires Java to run, so install Java (e.g., OpenJDK 11):

bash
Copy code
sudo apt install openjdk-11-jdk
You can verify Java installation by running:

bash
Copy code
java -version
2.3 Add Jenkins Repository and Key
To install Jenkins, first, add the Jenkins repository and its key:

Add the Jenkins repository:

bash
Copy code
wget -q -O - https://pkg.jenkins.io/jenkins.io.key | sudo tee /etc/apt/trusted.gpg.d/jenkins.asc
Add the Jenkins repository to your sources list:

bash
Copy code
sudo sh -c 'echo deb http://pkg.jenkins.io/debian/ / > /etc/apt/sources.list.d/jenkins.list'
2.4 Install Jenkins
Now, install Jenkins using apt:

bash
Copy code
sudo apt update
sudo apt install jenkins
This will download and install Jenkins along with its required dependencies.

3. Configure Jenkins as a Service
Jenkins will automatically be configured as a service during the installation process. The service will start on boot by default.

3.1 Start Jenkins
To start Jenkins, use the following command:

bash
Copy code
sudo systemctl start jenkins
3.2 Enable Jenkins to Start on Boot
To ensure that Jenkins starts automatically when your system boots up, run:

bash
Copy code
sudo systemctl enable jenkins
3.3 Check Jenkins Service Status
Verify that Jenkins is running as a service:

bash
Copy code
sudo systemctl status jenkins
You should see an output indicating that Jenkins is active and running. For example:

bash
Copy code
● jenkins.service - Jenkins Automation Server
   Loaded: loaded (/etc/systemd/system/jenkins.service; enabled; vendor preset: enabled)
   Active: active (running) since Sat 2024-12-15 12:34:56 UTC; 5 minutes ago
4. Open Jenkins Web Interface
By default, Jenkins runs on port 8080. To access the Jenkins web interface:

Open a browser and go to:

bash
Copy code
http://<your_server_ip>:8080
You will be prompted to enter an unlock key (initial admin password). To get this password, run the following command:

bash
Copy code
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
This will display a password that you can enter in the web interface to unlock Jenkins for the first time.

5. Complete Jenkins Setup
5.1 Install Suggested Plugins
Once you've logged into Jenkins, it will ask if you want to install the suggested plugins. It's recommended to click Install Suggested Plugins as this will install a set of essential plugins for Jenkins to work efficiently.

5.2 Create First Admin User
After the plugins are installed, you will be prompted to create your first Jenkins admin user. Fill in the required details to create the user.

6. Access Jenkins Web Interface
You should now be able to access Jenkins from the web interface at:

bash
Copy code
http://<your_server_ip>:8080
Log in using the credentials you created in step 5.2.
