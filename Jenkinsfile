pipeline {
    agent {
        label "Agent-ubuntu"
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
    }
}
