# **Lab 23: Jenkins Pipeline for Application Deployment**

## **Objective**

Create a Jenkins pipeline that automates the following processes:

- Build a Docker image from the Dockerfile in GitHub.
- Push the image to Docker Hub.
- Edit the new image in the `deployment.yaml` file.
- Deploy the application to Kubernetes (K8s).
- Make any **Post action** in your Jenkinsfile.

Repository: [Lab GitHub Repository](https://github.com/IbrahimAdell/Lab.git)

---

## **1. Prerequisites**

Before starting this lab, ensure that you have the following:

- Jenkins installed and running.
- Jenkins with the **Docker**, **Kubernetes**, and **GitHub** plugins installed.
- Access to a Docker Hub account.
- A running Kubernetes cluster with `kubectl` configured.
- The GitHub repository URL: [https://github.com/IbrahimAdell/Lab.git](https://github.com/IbrahimAdell/Lab.git).
- A **deployment.yaml** file for Kubernetes.
- A Dockerfile in the GitHub repository.

---

## **2. Configure Jenkins with Docker and Kubernetes**

### **2.1 Install Docker and Kubernetes Plugins in Jenkins**

1. Go to **Manage Jenkins** > **Manage Plugins**.
2. Install the following plugins:
   - **Docker Pipeline**: For Docker operations.
   - **Kubernetes**: For interacting with Kubernetes clusters.

### **2.2 Set Up Docker Hub Credentials**

1. Go to **Manage Jenkins** > **Manage Credentials**.
2. Under **(global)**, add new **Docker Hub credentials** (username and password).
   - Click **Add Credentials**.
   - Choose **Username with password**.
   - Enter your **Docker Hub credentials** and give them an ID (e.g., `docker-hub-credentials`).

### **2.3 Set Up Kubernetes Credentials**

1. Go to **Manage Jenkins** > **Manage Credentials**.
2. Add your Kubernetes cluster credentials (e.g., kubeconfig or token) for Jenkins to access the Kubernetes cluster.

---

## **3. Clone GitHub Repository into Jenkins**

### **3.1 Create a New Jenkins Pipeline Job**

1. Go to the **Jenkins Dashboard**.
2. Click **New Item** and select **Pipeline**.
3. Name the job (e.g., `Application-Deployment-Pipeline`).
4. Under **Pipeline**, select **Pipeline script from SCM**.
5. Choose **Git** as the SCM.
6. Enter the Git repository URL: `https://github.com/IbrahimAdell/Lab.git`.
7. Provide credentials if necessary.

---

## **4. Write Jenkinsfile for Application Deployment**

The Jenkinsfile will automate the process of building the Docker image, pushing it to Docker Hub, updating the `deployment.yaml`, and deploying to Kubernetes.

### **4.1 Create Jenkinsfile**

Create a `Jenkinsfile` in the root of the repository (if not already present). The following is an example pipeline script that meets the objective.

```groovy
pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'your-docker-username/your-image-name:latest'
        DOCKER_HUB_CREDENTIALS = 'docker-hub-credentials'
        K8S_CREDENTIALS = 'k8s-credentials'
    }
    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository
                git 'https://github.com/IbrahimAdell/Lab.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image from the Dockerfile in the GitHub repository
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub and push the image
                    docker.withRegistry('', DOCKER_HUB_CREDENTIALS) {
                        sh 'docker push ${DOCKER_IMAGE}'
                    }
                }
            }
        }
        stage('Update Deployment YAML') {
            steps {
                script {
                    // Update the deployment.yaml with the new image
                    sh """
                    sed -i 's|image: .*$|image: ${DOCKER_IMAGE}|' deployment.yaml
                    """
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Deploy to Kubernetes using kubectl
                    withKubeConfig(credentialsId: K8S_CREDENTIALS) {
                        sh 'kubectl apply -f deployment.yaml'
                    }
                }
            }
        }
        stage('Post Deployment Action') {
            steps {
                script {
                    // Any additional post-deployment steps can go here
                    echo 'Deployment complete! Performing post deployment tasks...'
                }
            }
        }
    }
    post {
        always {
            // Cleanup or notifications after pipeline execution
            echo 'Pipeline execution finished!'
        }
        success {
            echo 'Deployment was successful!'
        }
        failure {
            echo 'Deployment failed. Please check the logs.'
        }
    }
}
