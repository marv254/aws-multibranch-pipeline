---

# COmplete CI/CD Pipeline with Jenkins

This repository demonstrates a **complete CI/CD pipeline** built using **Jenkins Multibranch Pipeline** to build a Java application, containerize it with Docker, provision AWS infrastructure using Terraform, and deploy the application to an EC2 instance via SSH.

In this setup, **Jenkins is already running as a Docker container on a DigitalOcean cloud server**, acting as the CI/CD control plane.

---

## 🧱 Environment Setup

### Jenkins Environment

* Jenkins is deployed as a **Docker container** on a **DigitalOcean cloud server**
* Jenkins is responsible for:

  * Source code checkout
  * Pipeline execution
  * Infrastructure provisioning
  * Application deployment

The Jenkins container has access to the host Docker daemon to allow Docker image builds.

---

## 🔧 Jenkins Prerequisites & Configuration

### Jenkins Plugins Installed

The following plugins are required and installed:

* **Pipeline**
* **Multibranch Pipeline**
* **Git / GitHub Branch Source**
* **Docker Pipeline**
* **SSH Agent Plugin**
* **Credentials Binding Plugin**

The **SSH Agent plugin** is required to securely inject SSH private keys into the pipeline during the deployment stage.

---

## 🔐 Jenkins Credentials Configuration

All sensitive information is securely stored using **Jenkins Credentials**.

### Configured Credentials

| Credential ID     | Type                    | Purpose                           |
| ----------------- | ----------------------- | --------------------------------- |
| `aws-creds`       | AWS Access Key & Secret | Provision AWS infrastructure      |
| `dockerhub-creds` | Username & Password     | Authenticate with Docker registry |
| `ec2-ssh`         | SSH Private Key         | SSH access to EC2 instance        |

* AWS credentials are used by Terraform to create and manage AWS resources.
* Docker credentials allow Jenkins to push images to the container registry.
* The SSH private key pair is used by the **SSH Agent plugin** to securely connect to the EC2 instance during deployment.

---

## 🧰 Tools Installed on Jenkins

The following tools are installed inside the Jenkins environment (or available on the Jenkins host):

* **Docker**
* **Terraform**
* **Git**
* **Java**
* **Maven**

These tools are required for building the application, containerizing it, provisioning infrastructure, and deploying the application.

---

## ☁️ Terraform Remote State Configuration

* An **S3 bucket** was created in AWS to store the **Terraform remote state file**.
* Terraform is configured to use this S3 bucket as its backend.
* This ensures:

  * State persistence across pipeline runs
  * Safe and consistent infrastructure management
  * Collaboration-ready infrastructure changes

---

## 🔄 CI/CD Pipeline Stages

### 1️⃣ Build Application

* Jenkins checks out the source code from the repository.
* The Java application is built using Maven:

  ```bash
  mvn clean package
  ```
* The build generates a deployable application artifact.

---

### 2️⃣ Build & Push Docker Image

* Jenkins authenticates to the Docker registry using stored credentials.
* The Docker image is built using the provided `Dockerfile`.
* The image is tagged and pushed to the Docker registry.

This ensures the application is packaged in a consistent and portable format.

---

### 3️⃣ Provision Infrastructure (AWS)

* Terraform is executed from the pipeline to provision AWS resources.
* Infrastructure includes:

  * EC2 instance
  * Security groups
  * Networking components (as defined in Terraform)
* Terraform uses:

  * AWS credentials stored in Jenkins
  * S3 backend for remote state storage

Infrastructure provisioning is fully automated and repeatable.

---

### 4️⃣ Deploy Application

* Jenkins uses the **SSH Agent plugin** to load the SSH private key.
* Jenkins establishes an SSH connection to the EC2 instance.
* Deployment steps include:

  * Copying deployment scripts and Docker Compose files
  * Pulling the latest Docker image on the server
  * Running containers using Docker Compose

The application is deployed without manual intervention.

---

## 🔁 Multibranch Pipeline Behavior

* Jenkins automatically scans all repository branches.
* Any branch containing a `Jenkinsfile` is automatically built.
* This supports feature development, testing, and production workflows.

---

## ✅ Key Benefits

* Jenkins running in Docker on DigitalOcean
* Secure credential management via Jenkins
* Infrastructure as Code with Terraform
* Remote Terraform state stored in S3
* Dockerized application delivery
* Automated AWS provisioning and deployment
* Scalable multibranch CI/CD workflow

---

## 📌 Summary

This project demonstrates a **production-style CI/CD pipeline** where:

* Jenkins runs as a container in the cloud
* Credentials are securely managed
* Infrastructure is provisioned dynamically on AWS
* Applications are built, containerized, and deployed automatically
* Terraform state is safely stored remotely in S3

---

