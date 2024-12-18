# **Lab 28: Deployment vs. StatefulSet**

## **Prerequisites**

### **1. Install kubectl**
Follow the [official Kubernetes guide](https://kubernetes.io/docs/tasks/tools/) to install kubectl for your operating system.

### **2. Access to a Kubernetes Cluster**
Ensure you have access to a functional Kubernetes cluster. You can use Minikube, a cloud-based Kubernetes cluster, or an OpenShift cluster.

### **3. Verify Cluster Access**
Confirm that `kubectl` is configured and can access the cluster:
```bash
kubectl get nodes
```

### **4. Familiarity with YAML Configuration Files**
Ensure you are comfortable writing and applying YAML configuration files for Kubernetes resources.

---

## **Task Details**

### **1. Compare Deployment vs. StatefulSet**
Deployments and StatefulSets are both Kubernetes resources used to manage pods, but they serve different purposes:

| Feature                    | **Deployment**                                      | **StatefulSet**                                |
|----------------------------|----------------------------------------------------|------------------------------------------------|
| **Purpose**                | General-purpose application management.           | Manages stateful applications.                |
| **Pod Identity**           | Pods are interchangeable and stateless.           | Pods have unique, stable identities.          |
| **Scaling**                | Easily scales up or down without ordering.        | Scales pods in a defined order (sequential).  |
| **Persistent Storage**     | Requires manual configuration of Persistent Volumes (PVs). | Automatically binds Persistent Volume Claims (PVCs) to pods. |
| **Use Case**               | Stateless applications like web servers.          | Stateful applications like databases.         |
| **Rolling Updates**        | Seamless rolling updates.                         | Maintains pod order during updates.           |

---

### **2. Create a YAML File for a MySQL StatefulSet**
Here is a sample YAML configuration for a MySQL StatefulSet:

#### **mysql-statefulset.yaml**
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
  labels:
    app: mysql
spec:
  serviceName: mysql
  replicas: 3
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:5.7
        ports:
        - containerPort: 3306
          name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: rootpassword
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
  volumeClaimTemplates:
  - metadata:
      name: mysql-data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

#### **Explanation:**
- **`serviceName`**: Ensures that the StatefulSet pods are reachable through a consistent DNS name.
- **`replicas`**: Defines the number of replicas.
- **`volumeClaimTemplates`**: Automatically creates Persistent Volume Claims for each pod.
- **`env`**: Specifies the root password for MySQL.

Apply the YAML file:
```bash
kubectl apply -f mysql-statefulset.yaml
```
Verify the StatefulSet and pods:
```bash
kubectl get statefulsets
kubectl get pods
```

---

### **3. Write a YAML File for a Service for MySQL StatefulSet**
To enable access to the MySQL StatefulSet, define a Service:

#### **mysql-service.yaml**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
  labels:
    app: mysql
spec:
  ports:
  - port: 3306
    targetPort: 3306
  clusterIP: None
  selector:
    app: mysql
```

#### **Explanation:**
- **`clusterIP: None`**: Ensures headless service, allowing direct communication between pods.
- **`selector`**: Matches the labels of the MySQL pods.

Apply the YAML file:
```bash
kubectl apply -f mysql-service.yaml
```

Verify the service:
```bash
kubectl get svc
```

Test connectivity:
```bash
kubectl exec -it <mysql-pod-name> -- mysql -u root -p
```

---

## **Cleanup**
Remove the StatefulSet and service after completing the tasks:
```bash
kubectl delete -f mysql-statefulset.yaml
kubectl delete -f mysql-service.yaml
```

---



---

