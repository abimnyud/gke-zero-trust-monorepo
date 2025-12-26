# GKE Zero Trust Monorepo

This repository is a demonstration of modern Backend and DevOps practices, featuring a microservices architecture orchestrated on Google Kubernetes Engine (GKE) and secured using Zero Trust principles with Cloudflare Tunnels.

## 🎯 Project Goals

This project serves as a portfolio piece to demonstrate proficiency in:

*   **Backend Development**: Building scalable, modular microservices using **NestJS** and **TypeScript**.
*   **API Documentation**: Automatic API documentation generation using **Swagger/OpenAPI**.
*   **Containerization**: Dockerizing applications for consistent deployment environments.
*   **Orchestration**: Managing complex application lifecycles using **Kubernetes (K8s)**.
*   **Cloud Infrastructure**: Utilizing Google Cloud Platform (**GKE**, **GCR**) for production-grade hosting.
*   **Zero Trust Security**: Implementing secure, outbound-only connections using **Cloudflare Tunnels** to expose services without opening public firewall ports.

## 🏗 Architecture

The project is structured as a monorepo containing:

### Services
*   **swagger-testing-1**: A NestJS microservice providing a set of RESTful APIs with Swagger documentation.
*   **swagger-testing-2**: A second NestJS microservice demonstrating service isolation and independent scaling.

### Infrastructure (`/k8s`)
*   **Kubernetes Manifests**: Declarative configuration for Deployments, Services, and Ingress.
*   **Cloudflare Tunnel**: A sidecar/deployment configuration (`cloudflared`) to securely connect the K8s cluster to the Cloudflare Edge, enabling secure remote access.
*   **GKE Ingress**: Standard Ingress configuration for Google Cloud Load Balancing.

## 🚀 Technologies

*   **Language**: TypeScript, Node.js
*   **Framework**: NestJS
*   **Containerization**: Docker
*   **Orchestration**: Kubernetes
*   **Cloud Provider**: Google Cloud Platform (GKE)
*   **Networking/Security**: Cloudflare Tunnel (Zero Trust), GKE Ingress

## 🛠 Project Structure

```text
gke-zero-trust-monorepo/
├── k8s/                       # Kubernetes manifests (Deployments, Services, Ingress)
├── swagger-testing-1/         # NestJS Microservice 1
│   ├── src/
│   ├── Dockerfile
│   └── package.json
├── swagger-testing-2/         # NestJS Microservice 2
│   ├── src/
│   ├── Dockerfile
│   └── package.json
└── README.md
```

## 💻 Getting Started

### Prerequisites

*   **Node.js** & **npm**
*   **Docker**
*   **Kubectl** configured with a GKE cluster context
*   **Google Cloud SDK** (gcloud)
*   **Cloudflare Account** (if testing the tunnel)

### Local Development

Each service can be run locally for development purposes.

1.  Navigate to a service directory:
    ```bash
    cd swagger-testing-1
    ```

2.  Install dependencies:
    ```bash
    npm install
    ```

3.  Run the application:
    ```bash
    npm run start:dev
    ```

4.  Access Swagger UI at `http://localhost:3000/api` (default path for NestJS Swagger).

### Deployment to GKE

#### 1. Build and Push Docker Images

You need to build the images for the services and push them to a container registry (e.g., Google Container Registry).

```bash
# Example for swagger-testing-1
cd swagger-testing-1
docker build -t gcr.io/[PROJECT_ID]/swagger-testing-1/swagger-testing-1-image:tag1 .
docker push gcr.io/[PROJECT_ID]/swagger-testing-1/swagger-testing-1-image:tag1

# Repeat for swagger-testing-2
```

*Note: Update the image references in `k8s/*.yaml` files to match your registry URL.*

#### 2. Configure Cloudflare Tunnel (Optional)

If using the Zero Trust component:

1.  Obtain a Cloudflare Tunnel token.
2.  Update `k8s/cloudflared-deployment.yaml`:
    ```yaml
    args:
    - --token
    - [YOUR_CLOUDFLARED_TOKEN]
    ```
    *(Ideally, use a Kubernetes Secret for the token instead of hardcoding it in the manifest).*

#### 3. Apply Kubernetes Manifests

Deploy the services, ingress, and tunnel agents to your cluster.

```bash
# Deploy services
kubectl apply -f k8s/swagger-testing-1-deployment.yaml
kubectl apply -f k8s/swagger-testing-2-deployment.yaml

# Deploy Ingress
kubectl apply -f k8s/ingress-service.yaml

# Deploy Cloudflare Tunnel
kubectl apply -f k8s/cloudflared-deployment.yaml
```

#### 4. Verification

Check the status of your pods and services:

```bash
kubectl get pods
kubectl get services
kubectl get ingress
```

Once the Ingress IP is assigned (or the Tunnel is active), you can access your services via the configured domain paths:

*   `/swagger-testing-1/`
*   `/swagger-testing-2/`

## 🔒 Security Highlights

This project demonstrates a "Zero Trust" approach by utilizing **Cloudflare Tunnels**.
- **No Open Ports**: The `cloudflared` daemon creates an outbound-only connection to the Cloudflare Edge.
- **Secure Access**: Access to the internal K8s services can be gated behind Cloudflare Access (SSO, MFA) without exposing the cluster's public IP addresses directly to the internet.