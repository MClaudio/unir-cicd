pipeline {
    agent none
    stages {
        stage('Source') {
            agent any
            steps {
                git 'https://github.com/MClaudio/unir-cicd.git'
            }
        }
        stage('Build') {
            agent {
                docker {
                    image 'buildpack-deps:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                echo 'Building stage!'
                sh 'make build'
            }
        }
        stage('Unit tests') {
            agent {
                docker {
                    image 'buildpack-deps:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh 'make test-unit'
                archiveArtifacts artifacts: 'results/unit_*.xml'
            }
        }
        stage('API tests') {
            agent {
                docker {
                    image 'buildpack-deps:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh 'make test-api'
                archiveArtifacts artifacts: 'results/api_*.xml'
            }
        }
        stage('E2E tests') {
            agent {
                docker {
                    image 'buildpack-deps:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh 'make test-e2e'
                archiveArtifacts artifacts: 'results/e2e_*.xml'
            }
        }
    }
    post {
        always {
            node {
                junit 'results/*.xml'
                cleanWs()
            }
        }
        failure {
            emailext (
                subject: "Fallo en el pipeline: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "El pipeline ha fallado.\n\nJob: ${env.JOB_NAME}\nBuild: ${env.BUILD_NUMBER}",
                to: 'claum0395@gmail.com'
            )
        }
    }
}