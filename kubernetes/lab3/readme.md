# Lab 29: Storage Configuration

## **Prerequisites**
- A Kubernetes cluster set up and running.
- `kubectl` CLI tool installed and configured to interact with the cluster.

## **Objective**
Configure storage for an NGINX deployment in Kubernetes and ensure file persistence across pod restarts and deletions. Compare Persistent Volumes (PV), Persistent Volume Claims (PVC), and Storage Classes.

---

## **Steps**

### **1. Create the Deployment**

**Command:**
```bash
kubectl create deployment my-deployment --image=nginx --replicas=1
```

**Check the status of the deployment and pod:**
```bash
kubectl get deployment my-deployment
kubectl get pods
```

### **2. Exec into the NGINX Pod and Create the File**

**Exec into the NGINX pod:**
```bash
kubectl exec -it <pod-name> -- /bin/bash
```
Replace `<pod-name>` with the actual pod name from the previous step.

**Create a file:**
```bash
echo "hello, this is <your-name>" > /usr/share/nginx/html/hello.txt
```

**Verify the file is served by NGINX:**
```bash
curl localhost/hello.txt
```

### **3. Delete the NGINX Pod and Wait for a New Pod to be Created**

**Delete the pod:**
```bash
kubectl delete pod <pod-name>
```

**Wait for a new pod to be created:**
```bash
kubectl get pods
```

### **4. Exec into the New Pod and Verify the File is Gone**

**Exec into the new pod:**
```bash
kubectl exec -it <new-pod-name> -- /bin/bash
```

**Check if the file exists:**
```bash
cat /usr/share/nginx/html/hello.txt
```

---

### **5. Create a PVC and Modify the Deployment to Attach the PVC**

#### **Create a Persistent Volume Claim (PVC)**

**Create a `pvc.yaml` file with the following content:**
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nginx-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

**Apply the PVC:**
```bash
kubectl apply -f pvc.yaml
```

#### **Modify the Deployment to Attach the PVC**

**Create a `deployment-with-pvc.yaml` file with the following content:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        volumeMounts:
        - name: nginx-storage
          mountPath: /usr/share/nginx/html
      volumes:
      - name: nginx-storage
        persistentVolumeClaim:
          claimName: nginx-pvc
```

**Apply the updated deployment:**
```bash
kubectl apply -f deployment-with-pvc.yaml
```

---

### **6. Repeat the Previous Steps and Verify Persistence**

**Exec into the NGINX Pod and Create the File Again:**
```bash
kubectl exec -it <pod-name> -- /bin/bash
echo "hello, this is <your-name>" > /usr/share/nginx/html/hello.txt
curl localhost/hello.txt
```

**Delete the NGINX Pod:**
```bash
kubectl delete pod <pod-name>
```

**Exec into the new pod and verify the file exists:**
```bash
kubectl exec -it <new-pod-name> -- /bin/bash
cat /usr/share/nginx/html/hello.txt
```

---

### **7. Compare PV, PVC, and StorageClass**

#### **Persistent Volumes (PV)**
- **Definition:** A piece of storage in the cluster provisioned by an admin or dynamically via a StorageClass.
- **Features:**
  - Decouples storage from applications.
  - Provides data persistence across pod restarts.
  - Enforces access modes (e.g., ReadWriteOnce).

#### **Persistent Volume Claims (PVC)**
- **Definition:** A request for storage by a user.
- **Features:**
  - Enables resource requests (e.g., storage size, access modes).
  - Supports dynamic provisioning with StorageClasses.
  - Simplifies storage management for developers.

#### **Storage Classes**
- **Definition:** Defines the type of storage (e.g., SSD, cloud storage) and provisioning policies.
- **Features:**
  - Enables dynamic provisioning of PVs.
  - Supports various storage backends like AWS EBS, GCEPersistentDisk.
  - Facilitates scalability and automation.

---

### **Conclusion**
By using PVCs and StorageClasses, you ensure persistent storage for Kubernetes applications. This lab demonstrated the steps to achieve file persistence across pod restarts and deletions using Kubernetes storage primitives.


