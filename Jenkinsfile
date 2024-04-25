pipeline {
    agent {
        label "jenkins_agent"
    }
    tools {
        maven 'maven-path'
    }
    stages {
        stage('Fetch code') {
            steps {
                // Checkout the Git repository
                checkout scm
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
        stage('Dependency-check') {
            steps {
                dependencyCheck additionalArguments: '--format HTML', odcInstallation: 'depend-check'
            }
        }
        
        stage ("Docker Pull Dastardly from Burp Suite container image") {
            steps {
                sh 'docker pull public.ecr.aws/portswigger/dastardly:latest'
            }
        }
        stage ("Docker run Dastardly from Burp Suite Scan") {
            steps {
                cleanWs()
                sh '''
                    docker run --user $(id -u) -v ${WORKSPACE}:${WORKSPACE}:rw \
                    -e BURP_START_URL=https://ginandjuice.shop/ \
                    -e BURP_REPORT_FILE_PATH=${WORKSPACE}/dastardly-report.xml \
                    public.ecr.aws/portswigger/dastardly:latest
                '''
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
        
        stage('Docker Build') {
            steps {
                sh 'docker build --no-cache -t sneproject/maven-app .'
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
                sh 'docker run -d -p 5050:8080 sneproject/maven-app'
            }
        }
    }
    
    post {
        always {
            junit testResults: 'dastardly-report.xml', skipPublishingChecks: true
        }
    }
}
