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
                script {
                    def scannerHome = tool 'SonarScanner'
                    withEnv(["PATH+SCANNER=${scannerHome}/bin"]) {
                        sh "sonar-scanner -Dsonar.host.url=http://10.1.1.210:9000 -Dsonar.login=admin -Dsonar.password=vanelnara -Dsonar.java.binaries=src/main/java/com/visualpathit/account"
                    }
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
