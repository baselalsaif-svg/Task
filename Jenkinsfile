pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'U', passwordVariable: 'P')]) {
          sh '''
            set -e
            if command -v docker >/dev/null 2>&1; then D=docker;
            elif [ -x /usr/local/bin/docker ]; then D=/usr/local/bin/docker;
            else D=/opt/homebrew/bin/docker; fi
            export DOCKER_CONFIG="$(mktemp -d)"
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
