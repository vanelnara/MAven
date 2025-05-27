pipeline {
    agent {
        label "ubuntu-Agent"
    }
    tools {
        maven 'maven'  // Match name in Jenkins global tool config
    }
    stages {
        stage('Fetch code') {
            steps {
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
    }
}
