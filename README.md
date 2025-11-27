DevOps Challenge — FastAPI Application

This is my submission for the DevOps assessment. The goal was to containerize a simple FastAPI app, deploy it to Kubernetes, implement a CI workflow, and ensure the solution follows security best practices.


Prerequisites

Before running the solution, make sure you have the following installed:

- Docker (to build and run containers)
- Minikube or Kind (for a local Kubernetes cluster)
- kubectl (Kubernetes CLI)
- Helm (to deploy charts)
- Terraform (to create namespace and resource quotas)
- Git (to clone and manage the repository)

Make sure all tools are installed and working before running the scripts.


Using setup.sh

I created a script called setup.sh to automate the deployment process. It performs the following tasks:

1. Builds the Docker image for the FastAPI app
2. Applies Terraform to create the Kubernetes namespace and resource quota
3. Deploys the Helm chart to the Kubernetes cluster

After running it, the app should be up in the cluster. 

How I Solved the “Port 80 vs Non-Root” Challenge
Running containers as non-root is important for security, but normally only root can bind to ports below 1024 (like port 80).
Here’s how I handled it:
       1. In the Dockerfile, I created a non-root user (appuser) and installed libcap2-bin.
       2. I gave the Python interpreter the CAP_NET_BIND_SERVICE capability using: setcap 'cap_net_bind_service=+ep' $(which python3). This allows the non-root process to bind to port 80 safely.
       3. In Kubernetes, I set the Helm chart’s securityContext to:
       - Run the container as non-root
       - Use a read-only root filesystem
       - Drop all capabilities except NET_BIND_SERVICE
This ensures the container is secure while still serving traffic on port 80 — a defense-in-depth approach.
Verification
I also created system-checks.sh to confirm:
- The container is running as a non-root user
- Port 80 is being used inside the container
- The FastAPI endpoint returns the expected JSON response
Expected output should show:
- UID inside the container is not 0
- A process is listening on port 80
      


