# **Kubernetes Deployment and Rollback**

## **Prerequisites**

### **1. Install kubectl**
Follow the installation guide for your OS from the official Kubernetes documentation: [Install kubectl](https://kubernetes.io/docs/tasks/tools/).

### **2. Verify Installation**
Run the following command to ensure `kubectl` is installed:
```bash
kubectl version --client
```

### **3. Access Cluster**
Log in to your Kubernetes cluster:

```bash
kubectl config set-cluster <cluster-name> \
  --server=https://<cluster-api-url> \
  --insecure-skip-tls-verify=true

kubectl config set-credentials <user> --token=<your-token>

kubectl config set-context <context-name> \
  --cluster=<cluster-name> \
  --user=<user>

kubectl config use-context <context-name>
```

### **4. Test Access**
Verify that you can access the cluster:
```bash
kubectl get nodes
```

## **Steps to Perform Tasks**

### **1. Deploy NGINX with 3 Replicas**
Create a deployment with the NGINX image and 3 replicas:
```bash
kubectl create deployment nginx --image=nginx --replicas=3
```

Verify the deployment and pods:
```bash
kubectl get deployments
kubectl get pods
```

#### **Sample Output:**
![Deployment and Pods Output](https://via.placeholder.com/600x200?text=Deployment+and+Pods+Output)

---

### **2. Expose the Deployment as a Service**
Expose the deployment with a ClusterIP service:
```bash
kubectl expose deployment nginx --type=ClusterIP --port=80 --name=nginx-service
```

Check the service:
```bash
kubectl get svc
```

#### **Sample Output:**
![Service Output](https://via.placeholder.com/600x200?text=Service+Output)

Forward a local port to access the service:
```bash
kubectl port-forward svc/nginx-service 8880:80
```

Test the service locally:
```bash
curl http://localhost:8880
```

---

### **3. Update the Deployment to Use the Apache (HTTPD) Image**
Update the image of the NGINX deployment to Apache:
```bash
kubectl set image deployment/nginx nginx=httpd --record
```

Verify the update:
```bash
kubectl get deployments
kubectl get pods
```

Test the updated deployment using the same port forwarding setup:
```bash
curl http://localhost:8880
```

---

### **4. View Deployment Rollout History**
Check the rollout history to confirm the update was recorded:
```bash
kubectl rollout history deployment/nginx
```

#### **Sample Output:**
![Rollout History](https://via.placeholder.com/600x200?text=Rollout+History)

---

### **5. Roll Back to the Previous Version**
Roll back the deployment to the previous version:
```bash
kubectl rollout undo deployment/nginx
```

Monitor the pods to confirm the rollback:
```bash
kubectl get pods -w
```

Verify the rollback:
```bash
kubectl rollout status deployment/nginx
```

Test the service again:
```bash
curl http://localhost:8880
```

---

### **6. Cleanup**
Delete the deployment and service:
```bash
kubectl delete deployment nginx
kubectl delete svc nginx-service
```

---



