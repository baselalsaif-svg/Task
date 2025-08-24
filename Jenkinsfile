pipeline {
  agent any
  environment {
    IMAGE =  
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    // Optional: pause so you can verify the generated Dockerfile in the build log
    stage('Show Dockerfile') {
      steps { sh 'sed -n "1,80p" Dockerfile || true' }
    }

    stage('Build & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                          usernameVariable: 'DOCKER_USER',
                                          passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            set -e
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker build -t "$IMAGE:$BUILD_NUMBER" -t "$IMAGE:latest" .
            docker push "$IMAGE:$BUILD_NUMBER"
            docker push "$IMAGE:latest"
            docker logout || true
          '''
        }
      }
    }
  }
}
