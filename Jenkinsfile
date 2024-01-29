pipeline {
    agent any
    environment {
        REPO = "s10-webmobile1-sub2/S10P12C202"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(
                        branches: [[name: 'fe']],
//                         extensions: [submodule(parentCredentials: true, trackingSubmodules: true)],
                        userRemoteConfigs: [[credentialsId: 'GitLab-Access-Token2', url: 'https://lab.ssafy.com/s10-webmobile1-sub2/S10P12C202.git']]
                )
            }
        }
        stage('Setup Environment') {
            steps {
                // dir("${env.WORKSPACE}/Easysign_fe"){
                //     script {
                //         sh "ls -al"
                //         sh "ls secure-settings -al"
                //         sh "chmod +x ./gradlew"
                //         sh "cp ./secure-settings/application.yml ./src/main/resources"
                //         sh "cp ./secure-settings/application-dev.yml ./src/main/resources"
                //         sh "ls ./src/main/resources -al"

                //     }
                // }
            }
        }
//		stage('Junit Test') {
//			steps {
//				sh "./gradlew test"
//			}
//		}
        stage("Build") {
            steps {
                script {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'Docker-hub', usernameVariable: 'DOCKER_USER_ID', passwordVariable: 'DOCKER_USER_PASSWORD']]) {
                        sh "docker build -t ${DOCKER_USER_ID}/front Easysign_fe"
                    }
                }
            }
        }
        stage("Login") {
            steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'Docker-hub', usernameVariable: 'DOCKER_USER_ID', passwordVariable: 'DOCKER_USER_PASSWORD']]) {
                    sh """
                        set +x
                        echo $DOCKER_USER_PASSWORD | docker login -u $DOCKER_USER_ID --password-stdin
                        set -x
                    """
                }
            }
        }
        stage("Tag and Push") {
            steps {
                script {
                     withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'Docker-hub', usernameVariable: 'DOCKER_USER_ID', passwordVariable: 'DOCKER_USER_PASSWORD']]) {
                        sh "docker push ${DOCKER_USER_ID}/fe"
                     }
                }
            }
        }
        stage('Prune old images'){
            steps{
                script{
                    sh "docker system prune --filter until=1h"
                }
            }
        }
        stage('Pull') {
            steps {
                script {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'Docker-hub', usernameVariable: 'DOCKER_USER_ID', passwordVariable: 'DOCKER_USER_PASSWORD']]) {
                        sh "docker pull ${DOCKER_USER_ID}/fe"
                    }
                }
            }
        }
        stage('Up') {
            steps {
                script {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'Docker-hub', usernameVariable: 'DOCKER_USER_ID', passwordVariable: 'DOCKER_USER_PASSWORD']]) {
                        try{
                            sh "docker rm -f fe || true"
                            sh "docker run -d --name back -p 8083:8080 ${DOCKER_USER_ID}/fe"
                        } catch (Exception e){
                            sh "docker restart fe"
                        }
                    }
                }
            }
        }
    }
//     post {
//         always {
//             script {
//                 def Author_ID = sh(script: "git show -s --pretty=%an", returnStdout: true).trim()
//                 def Author_Name = sh(script: "git show -s --pretty=%ae", returnStdout: true).trim()
//                 mattermostSend (color: 'good',
//                         message: "빌드 ${currentBuild.currentResult}: ${env.JOB_NAME} #${env.BUILD_NUMBER} by ${Author_ID}(${Author_Name})\n(<${env.BUILD_URL}|Details>)",
//                         endpoint: 'https://meeting.ssafy.com/hooks/q4qjarpscbf9pme4f46yiojzfe',
//                         channel: 'C107-Jenkins'
//                 )
//             }
//         }
//     }
}