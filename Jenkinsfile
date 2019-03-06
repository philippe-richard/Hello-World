pipeline {
    agent any
	environment {
                CREDENTIALS = credentials('zowe-credentials')
					}
    stages {
        stage('build') {
            environment {
                CREATE_PROFILE = "./jenkins/profileCreation.sh"
                BUILD_COBOL = "./jenkins/build.sh"
            }
            steps {
                sh 'npm --version'
                sh 'zowe --version'
                sh 'npm install'
                withCredentials([usernamePassword(credentialsId: 'zowe-credentials', usernameVariable: 'userid', passwordVariable: 'password')]) {
                    sh "chmod +x $CREATE_PROFILE && $CREATE_PROFILE"
					sh "chmod +x $BUILD_COBOL && $BUILD_COBOL"
                }
                
            }
        }
        stage('deploy') {
            environment {
                DEPLOY_SCRIPT = "./jenkins/deploy.sh"
            }
            steps {
			withCredentials([usernamePassword(credentialsId: 'zowe-credentials', usernameVariable: 'userid', passwordVariable: 'password')]) {
                   sh "chmod +x $DEPLOY_SCRIPT && $DEPLOY_SCRIPT"
            }
        }
        stage('test') {
            environment {
                TEST_SCRIPT = "./jenkins/test.sh"
            }
            steps {
			withCredentials([usernamePassword(credentialsId: 'zowe-credentials', usernameVariable: 'userid', passwordVariable: 'password')]) {
                sh "chmod +x $TEST_SCRIPT && $TEST_SCRIPT"
            }
        }
    }
}