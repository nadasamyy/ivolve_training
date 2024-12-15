# **Lab 3: Jenkins Shared Libraries**

## **Objective**

The objective of this task is to implement shared libraries in Jenkins to reuse code across multiple pipelines. We will create a shared library that handles common tasks and demonstrate its usage in different Jenkins pipelines.

---

## **1. Prerequisites**

Before starting, ensure the following:
- You have access to Jenkins with necessary permissions.
- Git repository access for the shared library.
- A basic understanding of Jenkins pipelines and Groovy scripting.

---

## **2. Setting Up the Jenkins Shared Library**

### **2.1 Create a New Git Repository for Shared Library**

1. **Create a new Git repository** for your Jenkins Shared Library. This will store your reusable code.

2. **Structure the repository** as follows:

    ```bash
    ├── vars/
    │   └── utility.groovy  # (Shared Utility Functions)
    ├── src/
    │   └── org/
    │       └── example/
    │           └── UtilityClass.groovy
    └── README.md
    ```

    - The **`vars`** directory contains global variables that can be directly accessed in the Jenkinsfile.
    - The **`src`** directory contains Groovy classes that can be imported into Jenkinsfiles.

### **2.2 Create the Groovy Scripts**

- **utility.groovy** (inside `vars` directory): This will define reusable utility functions.

    ```groovy
    // vars/utility.groovy
    def printMessage(String message) {
        return "Message: ${message}"
    }
    ```

- **UtilityClass.groovy** (inside `src/org/example/`): This is a class with methods that can be used by Jenkins pipelines.

    ```groovy
    // src/org/example/UtilityClass.groovy
    package org.example

    class UtilityClass {
        static String printMessage(String message) {
            return "Message: ${message}"  // Returns the message instead of echoing
        }
    }
    ```

---

## **3. Configure Jenkins to Use the Shared Library**

### **3.1 Add the Shared Library in Jenkins**

1. Go to **Manage Jenkins** > **Configure System**.
2. Scroll down to the **Global Pipeline Libraries** section.
3. Click **Add** to add a new library.
4. Fill in the following details:
   - **Name**: `jenkins-shared-library` (this will be the name you reference in Jenkinsfiles).
   - **Source Code Management**: Choose **Git** and enter the URL of your shared library repository.
   - **Branch**: Enter the branch you want to use (e.g., `main`).
   - **Default version**: Leave this as `master` or choose another branch as per your setup.

---

## **4. Create and Use the Shared Library in Jenkins Pipelines**

### **4.1 Sample Jenkinsfile**

Here’s an example of a Jenkinsfile that uses the shared library:

```groovy
@Library('jenkins-shared-library') _  // Load the shared library

pipeline {
    agent any
    stages {
        stage('Test Shared Library') {
            steps {
                script {
                    // Call the method from the shared library
                    def message = org.example.UtilityClass.printMessage('Shared Library Working!')
                    echo message
                }
            }
        }
    }
}
