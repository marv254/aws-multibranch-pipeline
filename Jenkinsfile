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
        stage ("provision server"){
            environment{
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
                TF_VAR_env_prefix = 'test'
            }
            steps {
                script{
                    dir("terraform"){
                        sh "terraform init"
                        sh "terraform apply --auto-approve"
                        EC2_PUBLIC_IP = sh(
                            script: "terraform output ec2_public_ip",
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }
        stage("deploy") {
            environment{
                DOCKER_CREDS = credentials('dockerhub-creds')
            }
            steps {
                script {
                echo "Waiting for EC2 Server to initialize " 
                sleep(time: 90, unit: "SECONDS")

                echo 'Deploying docker image to EC2...'
                echo "${EC2_PUBLIC_IP}"
                
                def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME} ${DOCKER_CREDS_USR} ${DOCKER_CREDS_PSW}"
                def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"

                sshagent(['server-ssh-key']) {
                    sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user"
                    sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ${ec2Instance}:/home/ec2-user"
                    sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"

                    }
                }
            }
        }  
        stage('commit version update'){
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'GitHub-token', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                        sh 'git config --global user.email "jenkinserver@devopsmarv.com"'
                        sh 'git config --global user.name "jenkins"'

                        sh 'git remote set-url origin https://$USER:$PASS@github.com/$USER/aws-multibranch-pipeline.git'
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:master'
                    }
                }
            }
             
    }
    }
} 