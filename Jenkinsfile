pipeline {
    agent {
        label 'docker'
    }
    stages {
        stage('Install Dependencies') {
            steps {
                sh '''
                    if [ -f install-dependencies.sh ]; then
                        sudo ./install-dependencies.sh
                    else
                        echo "Descargando script de instalación..."
                        wget https://raw.githubusercontent.com/tu-repositorio/install-dependencies.sh/main/install-dependencies.sh
                        chmod +x install-dependencies.sh
                        sudo ./install-dependencies.sh
                    fi
                '''
            }
        }
        stage('Source') {
            steps {
                git 'https://github.com/MClaudio/unir-cicd.git'
            }
        }
        stage('Build') {
            steps {
                echo 'Building stage!'
                sh 'make build'
            }
        }
        stage('Unit tests') {
            steps {
                sh 'make test-unit'
                archiveArtifacts artifacts: 'results/unit_*.xml'
            }
        }
        stage('API tests') {
            steps {
                sh 'make test-api'
                archiveArtifacts artifacts: 'results/api_*.xml'
            }
        }
        stage('E2E tests') {
            steps {
                sh 'make test-e2e'
                archiveArtifacts artifacts: 'results/e2e_*.xml'
            }
        }
    }
    post {
        always {
            junit 'results/*.xml'
            cleanWs()
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