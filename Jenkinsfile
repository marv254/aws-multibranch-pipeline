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
                    echo "Deploying the application..."
                    def dockerComposeCmd = "docker-compose -f docker-compose.yaml up --detach"
                    sshagent(['ec2-user']) {
                        sh "scp docker-compose.yaml ec2-user@54.252.8.66:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@54.252.8.66 ${dockerComposeCmd}"
                    }
                }
            }
        }               
    }
} 
