# AWS Multibranch Pipeline – `master` Branch

This branch defines a **Jenkins Multibranch Pipeline** that automates the build, containerization, deployment, and version management of a **Java Maven application**.  

The pipeline integrates with a **shared Jenkins library**, DockerHub, AWS (EC2), and GitHub for full CI/CD automation.


---

## 🚀 Pipeline Workflow

The pipeline (defined in `Jenkinsfile`) includes the following stages:

1. **Increment Version**  
   - Uses Maven `build-helper` and `versions` plugins to bump the application version in `pom.xml`.  
   - Updates the Docker image tag with `${version}-${BUILD_NUMBER}`.  

2. **Build App**  
   - Calls the shared library function `buildJar()` to compile and package the Java Maven application into a JAR file.  

3. **Build Image**  
   - Builds a Docker image of the application using the shared library functions.  
   - Authenticates to DockerHub (`dockerLogin()`) and pushes the image (`dockerPush()`).  

4. **Deploy**  
   - Copies `server-cmds.sh` and `docker-compose.yaml` to a remote **AWS EC2 instance** via `scp`.  
   - Executes the deployment script over SSH to run the new container.  

5. **Commit Version Update**  
   - Commits the updated `pom.xml` (new version) back to the GitHub repository.  
   - Uses Jenkins credentials (`GitHub-token`) for authenticated push.  

---

## 🔧 Requirements

To successfully run this pipeline, ensure the following are installed on the **Jenkins agent** (or controller if running builds there):

- [Maven](https://maven.apache.org/)  
- [Docker](https://docs.docker.com/get-docker/)  

Additionally:  
- Jenkins must have **AWS credentials** configured for deployments.  
- DockerHub credentials (`dockerhub-creds`) must be set up in Jenkins.  
- SSH credentials for the EC2 instance (`ec2-user`) must be added in Jenkins.  
- A **GitHub token** must be stored as `GitHub-token` in Jenkins credentials for pushing commits.

---

## ⚙️ Setup

1. Fork or clone this repository.  
2. In Jenkins, create a **Multibranch Pipeline** job pointing to this repo.  
3. Configure the following Jenkins credentials:
   - `dockerhub-creds` → DockerHub username/password  
   - `GitHub-token` → GitHub personal access token  
   - `ec2-user` → SSH private key for your EC2 instance  
   - (Optional) AWS access key/secret for future EKS deployments  
4. Ensure the Jenkins agent has the required tools installed (see above).  
5. Push changes → Jenkins automatically triggers the pipeline for the updated branch.  

---

## ✅ Summary

The `master` branch of this project sets up a **complete CI/CD pipeline** for a Java Maven application:
- Automatic versioning  
- Build and packaging  
- Docker image creation and publishing  
- Deployment to AWS EC2  
- Version updates committed back to GitHub  

This provides a **production-ready delivery workflow** for Java apps running in containerized environments.

---
