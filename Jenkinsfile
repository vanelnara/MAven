pipeline {
    agent {
        label "jenkins_agent"
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the Git repository
                checkout scm
            }
        }
        stage('Unit Tests') {
            steps {
                // Execute the job to perform unit tests
                build job: 'Perform_Unit_Tests', propagate: false
            }
        }
        stage('Integration Tests') {
            steps {
                // Execute the job to perform integration tests
                build job: 'Perform_Integration_Tests', propagate: false
            }
        }
        stage('SonarQube Analysis') {
            steps {
                // Perform SonarQube analysis
                script {
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
        }
    }
}
