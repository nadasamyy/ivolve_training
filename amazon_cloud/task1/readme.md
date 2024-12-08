# **Lab 12: AWS Security**

## **Objective**
Create AWS account, set billing alarm, create two IAM groups (admin and developer), and perform the following tasks:

1. Admin group has admin permissions.
2. Developer group has access only to EC2.
3. Create `admin-1` user with console access only and enable MFA.
4. Create `admin-2-prog` user with CLI access only.
5. List all users and groups using AWS CLI commands.
6. Create `dev-user` with programmatic and console access, then test its access to EC2 and S3.

---

## **Steps**

### **1. Create an AWS Account**
1. Visit the [AWS Signup Page](https://aws.amazon.com).
2. Click **Create an AWS Account**.
3. Enter your email, set a root user password, and provide the required details.
4. Verify your account via email and phone.
5. Select a support plan (**Basic Support** is free).

---

### **2. Set a Billing Alarm**
1. Open the **AWS Billing and Cost Management Console**.
2. Navigate to **Billing Preferences** and enable receiving billing alerts.
3. Open the **Amazon CloudWatch Console**.
4. Create an alarm:
   - Go to **Alarms > All Alarms > Create Alarm**.
   - Choose a metric related to billing (e.g., `EstimatedCharges`).
   - Set a threshold (e.g., `$10`).
   - Configure notifications (email or SMS).
   - Confirm the alarm setup.

---

### **3. Create Two IAM Groups**
1. Open the **IAM Management Console**.
2. Navigate to **Groups > Create Group**.
3. Create the following groups:
   - **Admin Group:**
     - Add the `AdministratorAccess` policy.
   - **Developer Group:**
     - Add the `AmazonEC2FullAccess` policy.

---

### **4. Create IAM Users**

#### **a. Create `admin-1` User (Console Access Only)**
1. Navigate to **Users > Add Users**.
2. Set the username to `admin-1`.
3. Select **AWS Management Console Access**.
4. Configure a password and uncheck programmatic access.
5. Assign the user to the **admin group**.
6. Enable MFA:
   - Open the **Users** section and select `admin-1`.
   - Go to **Security Credentials > Manage MFA**.
   - Use a virtual MFA device (e.g., Google Authenticator) to scan the QR code and complete the setup.

#### **b. Create `admin-2-prog` User (CLI Access Only)**
1. Navigate to **Users > Add Users**.
2. Set the username to `admin-2-prog`.
3. Select **Programmatic Access Only**.
4. Assign the user to the **admin group**.
5. Generate an **Access Key** and **Secret Key** (download securely).

#### **c. Create `dev-user` (Programmatic and Console Access)**
1. Navigate to **Users > Add Users**.
2. Set the username to `dev-user`.
3. Select **AWS Management Console Access** and **Programmatic Access**.
4. Assign the user to the **developer group**.
5. Generate an **Access Key** and **Secret Key** (download securely).

---

### **5. List All Users and Groups Using CLI**

#### **Configure CLI:**
1. Install AWS CLI if not already installed (Refer to the [AWS CLI Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)).
2. Run `aws configure` and enter the credentials for `admin-2-prog`.

#### **List Users:**
```bash
aws iam list-users
```

#### **List Groups:**
```bash
aws iam list-groups
```

---

### **6. Test Access for `dev-user`**

1. Log in to the **AWS Management Console** using `dev-user` credentials.

#### **Test Access to EC2:**
- Try to launch an EC2 instance.

#### **Test Access to S3:**
- Attempt to access an S3 bucket (this should fail since the policy is restricted to EC2).

---

## **Conclusion**
This lab covers setting up an AWS account, creating billing alarms, configuring IAM groups and users, testing user access permissions, and verifying operations through both the AWS Management Console and AWS CLI.


