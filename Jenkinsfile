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
                // Use the withSonarQubeEnv wrapper to configure SonarQube analysis
                withSonarQubeEnv('sonar-server') {
                    sh 'mvn sonar:sonar -Dsonar.login=admin -Dsonar.password=vanelnara'
                }
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn install -DskipTests'
            } 

            post {
                success {
                    echo 'Now Archiving it...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker-compose build'
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'sneproject', passwordVariable: 'bonjourvanel')]) {
                    sh '''
                        docker login -u sneproject -p bonjourvanel
                        docker push sneproject/maven-app
                    '''
                }
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker pull sneproject/maven-app'
                sh 'docker-compose -f docker-compose.yaml up -d'
            }
        }
    }
}
