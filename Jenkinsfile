#!/usr/bin.env groovy

library identifier: 'jenkins-shared-library@master', retriever: modernSCM(
    [$class: 'GitSCMSource',
    remote: 'https://github.com/marv254/jenkins-shared-library.git',
    credentialsID: 'dockerhub-creds'
    ]
)


pipeline {   
    agent any
    tools {
        maven 'Maven'
    }
    environment {
        IMAGE_NAME = 'marv254/java-maven-app:1.0'
    }
    stages {
        stage('build app') {
            steps {
                script{
                    echo 'Building the application'
                    buildJar()
                }
            }
        }

        stage("build image") {
            steps {
                script {
                    echo "Building the docker image ..."
                    sh "whoami"
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }

        stage("deploy") {
            steps {
                script {
                    def dockerCmd = "docker run -p 8080:8080 -d ${IMAGE_NAME}"
                    echo "Deploying the application..."
                    sshagent(['ec2-user']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@13.239.56.212 ${dockerCmd}"
                    }
                }
            }
        }               
    }
} 
