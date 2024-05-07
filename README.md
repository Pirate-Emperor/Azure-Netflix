# Azure-Netflix

## Overview

**Azure-Netflix** is a DevSecOps CI/CD pipeline project that builds, tests, scans, and deploys a web application similar to Netflix on Microsoft Azure. This pipeline integrates key DevSecOps practices, including code quality analysis, security scanning, containerization, and deployment using Terraform and Kubernetes. The project leverages Jenkins, SonarQube, Trivy, Prometheus, and Grafana to ensure a secure and seamless deployment process.

### For more details about the web application itself, see the `README` file in the `src` directory.

<br/>

## Setup Steps for Jenkins Pipeline

To set up the pipeline, complete the following prerequisites:

1. **Install Jenkins, Docker, and Trivy**
   - Ensure that Jenkins is installed and accessible.
   - Install Docker to facilitate container creation and deployment.
   - Set up Trivy for filesystem and Docker image vulnerability scanning.

2. **Set Up SonarQube and Obtain a TMDB API Key**
   - Start a SonarQube container using Docker for code quality analysis.
     ```bash
     docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
     ```
   - Obtain a TMDB API Key for accessing The Movie Database (TMDB) if required for the application.

3. **Install Prometheus and Grafana**
   - Use `nssm` (Non-Sucking Service Manager) to run Prometheus and Grafana as services locally or on a server.
   - Install Node Exporter or Windows Exporter for monitoring and configure it in `prometheus.yml` for visibility.

4. **Integrate Prometheus with Jenkins**
   - Install the Prometheus Plugin in Jenkins and connect it to your Prometheus server for monitoring CI/CD metrics.

5. **Set Up Email Notifications in Jenkins**
   - Generate an App Password in your Google Account.
   - Install the Email Extension plugin in Jenkins for email notifications.
   - Configure the email settings and add credentials for alerts.

6. **Install Required Plugins in Jenkins**
   - Essential plugins include JDK Installer, SonarQube Scanner, Node.js, OWASP Dependency Check, and Docker-related plugins.

7. **Docker Configuration and Image Deployment**
   - Install Docker-related plugins and configure DockerHub credentials to build and push images.
   - Use the following plugins:
     - Docker
     - Docker Pipeline
     - Docker Commons
     - Docker Build Step

8. **Build and Push Docker Image**
   - Build the Docker image and push it to DockerHub for deployment.

<br/>

## Deployment Steps

1. **Deploy Infrastructure Using Terraform**
   - Install Terraform and configure Azure or another cloud provider.
   - Use the Azure CLI to authenticate, then initialize, plan, and apply the Terraform configuration:

     ```bash
     terraform init
     terraform plan
     terraform apply
     ```

   - Optionally, set up an Azure Container Registry (ACR) to store Docker images. If the automated ACR setup fails, push the image manually to ACR.

2. **Deploy to Azure Kubernetes Service (AKS)**
   - Deploy the Docker image to AKS using Kubernetes and a YAML deployment file.
   - Retrieve AKS credentials with the following command:

     ```bash
     az aks get-credentials --resource-group <resource_group_name> --name <aks_name>
     ```

   - Apply the deployment YAML file to AKS and monitor the deployment:

     ```bash
     kubectl apply -f deployment.yml
     kubectl get service <service-name> --watch
     ```

   - This will provide an external IP address to access the application via a browser.

<br/>

![frontpage](https://github.com/user-attachments/assets/5119815e-0627-4a24-a540-0e7e92fc9f7f)

<br/>

## Jenkins Pipeline Configuration (Jenkinsfile)

Here is the full Jenkins pipeline configuration:

```groovy
pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout from Git') {
            steps {
                git branch: 'main', url: 'https://github.com/Pirate-Emperor/Azure-Netflix.git'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    bat ''' %SCANNER_HOME%\\bin\\sonar-scanner -D"sonar.projectName=Netflix" \
                    -D"sonar.projectKey=Netflix" '''
                }
            }
        }
        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                bat "npm install"
            }
        }
        stage('OWASP FS Scan') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('Trivy FS Scan') {
            steps {
                bat "trivy fs . > trivyfs.txt"
            }
        }
        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        bat "docker build --build-arg TMDB_V3_API_KEY=<your-api-key> -t netflix ."
                        bat "docker tag netflix your-docker-name/netflix:latest"
                        bat "docker push your-docker-name/netflix:latest"
                    }
                }
            }
        }
        stage('Trivy Image Scan') {
            steps {
                bat "trivy image your-docker-name/netflix:latest > trivyimage.txt"
            }
        }
    }
    post {
        always {
            emailext attachLog: true,
                subject: "'${currentBuild.result}'",
                body: "Project: ${env.JOB_NAME}<br/>" +
                      "Build Number: ${env.BUILD_NUMBER}<br/>" +
                      "URL: ${env.BUILD_URL}<br/>",
                to: 'your-emailid-configured',
                attachmentsPattern: 'trivyfs.txt,trivyimage.txt'
        }
    }
}
```

## Contributing

Feel free to fork the repository, make changes, and submit pull requests. Contributions are welcome!

## License

This project is licensed under the Pirate-Emperor License. See the [LICENSE](LICENSE) file for details.

## Author

**Pirate-Emperor**

[![Twitter](https://skillicons.dev/icons?i=twitter)](https://twitter.com/PirateKingRahul)
[![Discord](https://skillicons.dev/icons?i=discord)](https://discord.com/users/1200728704981143634)
[![LinkedIn](https://skillicons.dev/icons?i=linkedin)](https://www.linkedin.com/in/piratekingrahul)

[![Reddit](https://img.shields.io/badge/Reddit-FF5700?style=for-the-badge&logo=reddit&logoColor=white)](https://www.reddit.com/u/PirateKingRahul)
[![Medium](https://img.shields.io/badge/Medium-42404E?style=for-the-badge&logo=medium&logoColor=white)](https://medium.com/@piratekingrahul)

- GitHub: [Pirate-Emperor](https://github.com/Pirate-Emperor)
- Reddit: [PirateKingRahul](https://www.reddit.com/u/PirateKingRahul/)
- Twitter: [PirateKingRahul](https://twitter.com/PirateKingRahul)
- Discord: [PirateKingRahul](https://discord.com/users/1200728704981143634)
- LinkedIn: [PirateKingRahul](https://www.linkedin.com/in/piratekingrahul)
- Skype: [Join Skype](https://join.skype.com/invite/yfjOJG3wv9Ki)
- Medium: [PirateKingRahul](https://medium.com/@piratekingrahul)

---