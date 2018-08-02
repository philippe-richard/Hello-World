pipeline {
    agent { label 'ca-brightside-agent' }
    stages {
        stage('build') {
            steps {
                sh 'npm --version'
                sh 'bright --version'
                sh 'npm install'
            }
        }
    }
}