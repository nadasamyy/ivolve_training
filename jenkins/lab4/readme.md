# **Lab 25: Role-based Authorization**

## **Objective**

- **Create** user1 and user2.
- **Assign** admin role for user1.
- **Assign** read-only role for user2.

---

## **1. Prerequisites**

Ensure you have the following before starting:
- Jenkins instance installed and running.
- Administrative access to Jenkins.
- Jenkins **Role-Based Authorization Strategy** plugin installed.

### **To check/install the Role-Based Authorization Strategy plugin:**
1. Go to **Manage Jenkins**.
2. Click **Manage Plugins**.
3. In the **Available** tab, search for **Role-Based Authorization Strategy**.
4. If it's not installed, install it and restart Jenkins.

---

## **2. Enable Role-Based Authorization Strategy in Jenkins**

1. **Go to Jenkins Dashboard**.
2. Click **Manage Jenkins**.
3. Select **Configure Global Security**.
4. Under **Authorization**, select **Role-Based Strategy**.
5. Click **Save** to apply the changes.

---

## **3. Create Roles (Admin and Read-Only)**

### **3.1. Assign Roles**

Now that the Role-Based Authorization plugin is enabled, you can create the roles for **user1** and **user2**.

1. Go to **Manage Jenkins**.
2. Click **Manage and Assign Roles** > **Manage Roles**.
3. You will see the **Roles** section where you can add, edit, or remove roles.

#### **Create Admin Role**
- In the **Role** section, enter `admin` for the role name.
- Under **Permissions**, select the following for the **admin** role:
  - **Overall/Administer** (Grants full administrative permissions).
  - **Job/Build**, **Job/Configure**, **Job/Create**, etc. (Grants permissions to manage jobs).
  - **Overall/Read** (Grants read access to Jenkins).

Click **Save** once you’re done.

#### **Create Read-Only Role**
- In the **Role** section, enter `read-only` for the role name.
- Under **Permissions**, select the following for the **read-only** role:
  - **Overall/Read** (Grants read access to Jenkins).
  - **Job/Read** (Allows viewing jobs but not making any changes).

Click **Save** once you’re done.

---

## **4. Create Users**

### **4.1. Add User1 (Admin)**

1. Go to **Manage Jenkins** > **Manage Users**.
2. Click **Create User**.
3. Fill in the details for **user1** (e.g., username: `user1`, password: `password1`, etc.).
4. After creating the user, assign the **admin** role to **user1**:
   - Go to **Manage Jenkins** > **Manage and Assign Roles** > **Assign Roles**.
   - In the **User/group to add** section, type `user1`.
   - Under **Roles**, select **admin**.
5. Click **Save**.

### **4.2. Add User2 (Read-Only)**

1. Go to **Manage Jenkins** > **Manage Users**.
2. Click **Create User**.
3. Fill in the details for **user2** (e.g., username: `user2`, password: `password2`, etc.).
4. After creating the user, assign the **read-only** role to **user2**:
   - Go to **Manage Jenkins** > **Manage and Assign Roles** > **Assign Roles**.
   - In the **User/group to add** section, type `user2`.
   - Under **Roles**, select **read-only**.
5. Click **Save**.

---

## **5. Test the Role-Based Authorization**

### **5.1. Log in as Admin (user1)**

1. Log out of Jenkins and log in using **user1** credentials.
2. Verify that **user1** has full administrative permissions, including the ability to configure Jenkins, manage jobs, and view all system settings.

### **5.2. Log in as Read-Only User (user2)**

1. Log out of Jenkins and log in using **user2** credentials.
2. Verify that **user2** only has read-only access. They should be able to view jobs but not create or modify jobs or configure Jenkins.

---

## **6. Additional Notes**

- **Role-Based Access Control (RBAC)** helps ensure that different users have different levels of access based on their roles. This is especially important in production environments to maintain security and limit access.
- If you need to create additional roles in the future (e.g., for developers or testers), repeat the role creation and user assignment process for each new role.

---

## **7. Conclusion**

In this lab, we:
- Installed and enabled the **Role-Based Authorization Strategy** plugin.
- Created two roles: **admin** and **read-only**.
- Created two users, **user1** and **user2**, and assigned them the respective roles.
- Tested the roles to ensure the users had the appropriate permissions.

By implementing role-based authorization, you can securely control who has access to different parts of Jenkins and assign specific privileges to each user based on their role.
