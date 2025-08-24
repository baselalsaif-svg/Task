pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Verify Docker') {
      steps {
        sh '''
          set -e
          if command -v docker >/dev/null 2>&1; then
            docker version
          elif [ -x /usr/local/bin/docker ]; then
            /usr/local/bin/docker version
          elif [ -x /opt/homebrew/bin/docker ]; then
            /opt/homebrew/bin/docker version
          else
            echo "ERROR: Docker CLI not found."
            exit 127
          fi
        '''
      }
    }
    stage('Build & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'U', passwordVariable: 'P')]) {
          sh '''
            set -e
            if command -v docker >/dev/null 2>&1; then D=docker;
            elif [ -x /usr/local/bin/docker ]; then D=/usr/local/bin/docker;
            else D=/opt/homebrew/bin/docker; fi
            IMAGE=baselalsaif/task
            echo "$P" | $D login -u "$U" --password-stdin
            $D build -t "$IMAGE:latest" .
            $D push "$IMAGE:latest"
            $D logout || true
          '''
        }
      }
    }
  }
}
