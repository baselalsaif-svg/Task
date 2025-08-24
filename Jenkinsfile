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
            printf '{}' > "$DOCKER_CONFIG/config.json"

            if grep -qi '^FROM[[:space:]]*python' Dockerfile && [ ! -f requirements.txt ]; then
              : > requirements.txt
            fi
            if [ -f .dockerignore ] && grep -q '^requirements\\.txt$' .dockerignore; then
              grep -v '^requirements\\.txt$' .dockerignore > .dockerignore.tmp && mv .dockerignore.tmp .dockerignore
            fi

            IMAGE=baselalsaif/task
            $D build -t "$IMAGE:latest" .
            echo "$P" | $D login -u "$U" --password-stdin
            $D push "$IMAGE:latest"
            $D logout || true
          '''
        }
      }
    }
  }
}
