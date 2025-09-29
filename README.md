# AWS Multibranch Pipeline – `jenkins-jobs` Branch

This branch contains a **Jenkins Multibranch Pipeline** configuration for automating the **build, containerization, deployment, and version management** of a Java Maven application on AWS ECR and EKS.

---

## 🚀 What the Pipeline Does

The pipeline defined in the `Jenkinsfile` executes the following steps:

1. **Increment Version**
   - Uses Maven to bump the application version in `pom.xml`.
   - Generates a new version string (`major.minor.patch-buildNumber`).
   - Updates the environment variable `IMAGE_NAME` for Docker image tagging.

2. **Build Application**
   - Calls the shared library function `buildJar()` to package the Java application into a JAR file.
   - Ensures the app compiles and passes tests before containerization.

3. **Build Docker Image**
   - Builds a Docker image using the project `Dockerfile`.
   - Tags the image with the updated version number.
   - Logs in to **AWS Elastic Container Registry (ECR)** using Jenkins credentials.
   - Pushes the image to AWS ECR:
     ```
     701769180403.dkr.ecr.ap-southeast-2.amazonaws.com/java-maven-app
     ```

4. **Deploy to Kubernetes**
   - Uses `kubectl` with Kubernetes manifests (`deployment.yaml` and `service.yaml`).
   - Performs variable substitution (`envsubst`) before applying manifests.
   - Deploys the updated container image to the Kubernetes cluster.
   - AWS credentials are securely injected from Jenkins.

5. **Commit Version Update**
   - Commits the new version back into GitHub (`pom.xml` changes).
   - Pushes to the `jenkins-jobs` branch using a GitHub token.

---

## 🛠️ Tools & Technologies Used

- **Jenkins Multibranch Pipeline**
- **Jenkins Shared Library**: [jenkins-shared-library](https://github.com/marv254/jenkins-shared-library)
- **Maven**: Java build automation and version management
- **Docker**: Containerization
- **AWS ECR**: Container image registry
- **AWS EKS s**: Deployment environment
- **GitHub**: Version control and GitOps-style version tracking

---

---

## 📦 Packages Required on Jenkins Machine

To successfully run the pipeline, make sure the following tools are installed on the Jenkins agent (or master if it runs builds):

- **Docker** → for building and pushing container images  
- **kubectl** → for deploying to Kubernetes  
- **aws-iam-authenticator** → for authenticating to Amazon EKS clusters  
- **gettext-base** → provides `envsubst` for variable substitution in Kubernetes manifests  
- **Maven** → configured in Jenkins as a build tool  



--

## 🔑 Jenkins Credentials Required

The following credentials must be configured in Jenkins:

- `dockerhub-creds` → for accessing the Jenkins shared library  
- `ecr-creds` → AWS ECR login (username/password or token)  
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` → IAM user credentials for deployments  
- `GitHub-token` → Personal Access Token (PAT) for committing changes back to the repo  

---


## ⚙️ How to Use

1. Clone this repository and check out the `jenkins-jobs` branch.
2. In Jenkins, create a **Multibranch Pipeline Job** pointing to this repository.
3. Configure the required credentials in Jenkins.
4. Push code changes → Jenkins will automatically:
   - Increment the version,
   - Build and package the app,
   - Build and push a Docker image to AWS ECR,
   - Deploy to Kubernetes,
   - Commit the version bump back to GitHub.

---

## ✅ Summary

This pipeline provides a **full CI/CD workflow** for a Java Maven application:

- **Builds** and versions the app  
- **Packages** it into a Docker image  
- **Publishes** to AWS ECR  
- **Deploys** to Kubernetes  
- **Commits** version updates back to GitHub  

It ensures every change is traceable, versioned, and deployed automatically in a secure and repeatable way.




