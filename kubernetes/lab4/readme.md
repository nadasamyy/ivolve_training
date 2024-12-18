# **Lab 30: Kubernetes Security and RBAC**

## **Prerequisites**

### **1. Access to a Kubernetes Cluster**
Ensure you have access to a functional Kubernetes cluster and the `kubectl` CLI installed and configured.

### **2. Verify Cluster Access**
Confirm that you can communicate with the cluster:
```bash
kubectl cluster-info
```

### **3. Familiarity with Kubernetes RBAC Concepts**
Understand the basics of Kubernetes Role-Based Access Control (RBAC), including Service Accounts, Roles, RoleBindings, ClusterRoles, and ClusterRoleBindings.

---

## **Task Details**

### **1. Create a Service Account**
Create a Service Account named `pod-reader-sa` in your current namespace:

#### **Command:**
```bash
kubectl create serviceaccount pod-reader-sa
```

#### **Verify the Service Account:**
```bash
kubectl get serviceaccounts
```

---

### **2. Define a Role Named `pod-reader`**
This role allows read-only access to pods in the namespace.

#### **Role YAML File: `pod-reader-role.yaml`**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
```

#### **Apply the Role:**
```bash
kubectl apply -f pod-reader-role.yaml
```

#### **Verify the Role:**
```bash
kubectl get roles
```

---

### **3. Bind the `pod-reader` Role to the Service Account**
Create a RoleBinding to bind the `pod-reader` role to the `pod-reader-sa` Service Account.

#### **RoleBinding YAML File: `pod-reader-rolebinding.yaml`**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
subjects:
- kind: ServiceAccount
  name: pod-reader-sa
  namespace: default
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

#### **Apply the RoleBinding:**
```bash
kubectl apply -f pod-reader-rolebinding.yaml
```

#### **Verify the RoleBinding:**
```bash
kubectl get rolebindings
```

---

### **4. Get the ServiceAccount Token**
Retrieve the token for the Service Account to authenticate API requests:

#### **Commands:**
1. Find the secret associated with the Service Account:
   ```bash
   kubectl get secrets | grep pod-reader-sa
   ```

2. Describe the secret to view the token:
   ```bash
   kubectl describe secret <secret-name>
   ```

3. Use the token to authenticate:
   ```bash
   curl -H "Authorization: Bearer <token>" https://<cluster-api-url>/api/v1/namespaces/default/pods
   ```

---

### **5. Comparison of RBAC Components**

| **Component**         | **Description**                                                                                     |
|-----------------------|-----------------------------------------------------------------------------------------------------|
| **Service Account**    | Represents an identity for processes running in a pod to access the cluster.                       |
| **Role**               | Grants permissions within a namespace.                                                             |
| **RoleBinding**        | Binds a Role to a user, group, or Service Account within a namespace.                              |
| **ClusterRole**        | Grants permissions cluster-wide or within all namespaces.                                          |
| **ClusterRoleBinding** | Binds a ClusterRole to a user, group, or Service Account, giving permissions across the cluster.    |

| **Feature**          | **Role & RoleBinding**                                               | **ClusterRole & ClusterRoleBinding**                                |
|----------------------|---------------------------------------------------------------------|---------------------------------------------------------------------|
| **Scope**            | Namespace-specific.                                                | Cluster-wide or namespace-specific.                                |
| **Use Case**         | Fine-grained control for namespace resources.                     | Cross-namespace permissions or resources like nodes.               |
| **Typical Scenario** | Managing applications in a specific namespace.                   | Administering cluster-wide policies, managing nodes, or PVs.       |

---

## **Cleanup**
Remove all created resources after completing the tasks:

#### **Commands:**
```bash
kubectl delete serviceaccount pod-reader-sa
kubectl delete role pod-reader
kubectl delete rolebinding pod-reader-binding
```

---


