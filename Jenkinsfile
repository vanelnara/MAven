pipeline {
    agent {
        label "jenkins_agent"
    }
    tools {
        maven 'maven-path'
        // Define SonarQube installation
        sonarQubeScanner 'sonar-server'
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
                    // Use the defined SonarQube installation
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv("sonar-server") {
                        sh "mvn sonar:sonar"
                    }
                }
            }
        }
        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
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
