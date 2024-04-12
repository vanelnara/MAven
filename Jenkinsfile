pipeline {
    agent {
        label "jenkins_agent"
    }
    tools {
        maven 'maven-path'
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the Git repository
                checkout scm
            }
        }
        stage('Build & Unit Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Integration Test') {
            steps {
                sh 'mvn verify'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube_Server') {
                    sh '''
                        sonar-scanner \
                         -Dsonar.projectKey=Maven-project \
                         -Dsonar.sources=. \
                         -Dsonar.host.url=http://10.1.1.210:9000
                    '''
                }
            }
        }
        stage('Docker Build and Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'sneproject', passwordVariable: 'bonjourvanel')]) {
                    sh '''
                        docker build -t sneproject/maven-app .
                        docker login -u sneproject -p bonjourvanel
                        docker push sneproject/maven-app
                    '''
                }
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker pull sneproject/maven-app'
                sh 'docker run -d -p 5000:5000 sneproject/maven-app'
            }
        }
    }
}
