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
            environment{
                AWS_ACCESS_KEY_ID = credentials("AWS_ACCESS_KEY_ID")
                AWS_SECRET_ACCESS_KEY = credentials("AWS_SECRET_ACCESS_KEY")
            }
            steps {
                script {
                    echo "Deploying the application..."
                    sh "kubectl create deployment nginx-deployment --image=nginx"
                }
            }
        }               
    }
} 
