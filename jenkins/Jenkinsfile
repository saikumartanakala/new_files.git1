pipeline {
    agent {
        label 'remote-agent'  // Use the remote machine as the build agent
    }

    environment {
        REMOTE_DIR  = '/home/your-user/app'  // Deployment directory on remote machine
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build on Remote Machine') {
            steps {
                script {
                    sh '''
                    echo "Building the project on the remote agent..."
                    cd $WORKSPACE  # Jenkins workspace on remote agent
                    ./build.sh     # Modify this to match your build process
                    '''
                }
            }
        }

        stage('Deploy on Remote Machine') {
            steps {
                script {
                    sh '''
                    echo "Deploying the application on remote agent..."
                    cd $WORKSPACE
                    ./restart-service.sh  # Modify as per your deployment steps
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Build and Deployment completed successfully on remote agent!"
        }
        failure {
            echo "Build or Deployment failed!"
        }
    }
}
