# Network Configuration Lab

This lab demonstrates how to configure a custom NGINX service with restricted network access and expose it using an Ingress resource.

---

## **Steps**

### **1. Build a Docker Image**

**Clone the repository and build the Docker image:**
```bash
git clone https://github.com/IbrahimmAdel/static-website.git
cd static-website
docker build -t static-website:latest .
```

---

### **2. Create a Deployment**

**Create a deployment using the built image:**

**`static-website-deployment.yaml`**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: static-website
  labels:
    app: static-website
spec:
  replicas: 3
  selector:
    matchLabels:
      app: static-website
  template:
    metadata:
      labels:
        app: static-website
    spec:
      containers:
      - name: static-website
        image: static-website:latest
        ports:
        - containerPort: 80
```

**Apply the deployment:**
```bash
kubectl apply -f static-website-deployment.yaml
```

---

### **3. Expose the Deployment**

**Expose the deployment as a service:**
```bash
kubectl expose deployment static-website \
  --type=ClusterIP \
  --name=static-website-service \
  --port=80
```

---

### **4. Define a Network Policy**

**Create a network policy to restrict access:**

**`network-policy.yaml`**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ingress-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: static-website
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: default # Only allow from the default namespace
    - podSelector: {} # Allow from any pod within the default namespace
  policyTypes:
  - Ingress
```

**Apply the policy:**
```bash
kubectl apply -f network-policy.yaml
```

---

### **5. Enable NGINX Ingress Controller**

**Enable the Ingress controller:**
```bash
minikube addons enable ingress
```

---

### **6. Create an Ingress Resource**

**Define an Ingress resource to expose the service:**

**`ingress-resource.yaml`**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: static-website-ingress
spec:
  rules:
  - host: static-website.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: static-website-service
            port:
              number: 80
```

**Apply the Ingress resource:**
```bash
kubectl apply -f ingress-resource.yaml
```

---

### **7. Update /etc/hosts**

**Add the following entry to `/etc/hosts`:**
```bash
<Minikube-IP> static-website.local
```

**Find the Minikube IP:**
```bash
minikube ip
```

---

### **8. Access the Service**

**Access the custom NGINX service via the domain name:**
```bash
curl http://static-website.local
```

---

### **Conclusion**
By following these steps, you have successfully configured a custom NGINX service with restricted network access and exposed it using an Ingress resource in Kubernetes.

