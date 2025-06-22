#!/usr/bin.env groovy

pipeline {   
    agent any
    stages {
        stage("test") {
            steps {
                script {
                    echo "Testing the application..."

                }
            }
        }
        stage("build") {
            steps {
                script {
                    echo "Building the application..."
                }
            }
        }

        stage("deploy") {
            steps {
                script {
                    def dockerCmd = 'docker run -p 3080:3000 -d marvkorir/my-repo:my-app'
                    echo "Deploying the application..."
                    sshagent(['ec2-user']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@13.239.56.212 ${dockerCmd}"
                    }
                }
            }
        }               
    }
} 
