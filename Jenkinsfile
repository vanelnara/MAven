pipeline {
    agent {
        label "jenkins_agent"
    }
    tools {
        maven 'my-maven-3'
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
                sh 'mvn clean verify -DskipITs=true'
                junit '**/target/surefire-reports/TEST-*.xml'
                archiveArtifacts 'target/*.jar'
            }
        }
        stage('Integration Test') {
            steps {
                sh 'mvn clean verify -Dsurefire.skip=true'
                junit '**/target/failsafe-reports/TEST-*.xml'
                archiveArtifacts 'target/*.jar'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube_Server') {
                    sh '''
                        mvn clean verify sonar:sonar \
                        -Dsonar.projectKey=Maven-project \
                        -Dsonar.projectName='Maven-project' \
                        -Dsonar.host.url=http://10.1.1.210:9000 \
                        -Dsonar.login=sqp_574a3d28a7b25f17dbeb754813bc48db05aeb26f
                    '''
                }
            }
        }
        stage('Docker Build and Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        docker build -t $DOCKER_USERNAME/maven-app .
                        docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                        docker push $DOCKER_USERNAME/maven-app
                    '''
                }
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker pull $DOCKER_USERNAME/maven-app'
                sh 'docker run -d -p 8080:8080 $DOCKER_USERNAME/maven-app'
            }
        }
    }
}
