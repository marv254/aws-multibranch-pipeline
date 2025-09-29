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
        DOCKER_REPO = '701769180403.dkr.ecr.ap-southeast-2.amazonaws.com/java-maven-app'
        DOCKER_REPO_SERVER = '701769180403.dkr.ecr.ap-southeast-2.amazonaws.com'
        IMAGE_NAME = 'marv254/java-maven-app:1.0'
    }
    stages {
        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version...'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                }
            }
        }

        stage('build app') {
            steps {
                script{
                    echo 'Building the application'
                    buildJar()
                }
            }
        }

         stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                    withCredentials([usernamePassword(credentialsId: 'ecr-creds', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "docker build -t ${DOCKER_REPO}:${IMAGE_NAME} ."
                        sh "echo $PASS | docker login -u $USER --password-stdin ${DOCKER_REPO_SERVER}"
                        sh "docker push ${DOCKER_REPO}:${IMAGE_NAME} ${DOCKER_REPO_SERVER}"
                    }
                }
            }
        }

        stage("deploy") {
            environment{
                AWS_ACCESS_KEY_ID = credentials("AWS_ACCESS_KEY_ID")
                AWS_SECRET_ACCESS_KEY = credentials("AWS_SECRET_ACCESS_KEY")
                APP_NAME = "java-maven-app"
            }
            steps {
                script {
                    echo "Deploying the application..."
                    sh "envsubst < kubernetes/deployment.yaml | kubectl apply -f -"
                    sh "envsubst < kubernetes/service.yaml | kubectl apply -f -"
                
                }
            }
        }     
        stage('commit version update'){
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'GitHub-token', passwordVariable: 'PASS', usernameVariable: 'USER')]){
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
