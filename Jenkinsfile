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
    stage('Build image') {
      steps {
        sh '''
          set -e
          if command -v docker >/dev/null 2>&1; then D=docker;
          elif [ -x /usr/local/bin/docker ]; then D=/usr/local/bin/docker;
          else D=/opt/homebrew/bin/docker; fi
          IMAGE_ID=$($D build -q .)
          echo "$IMAGE_ID" | tee image_id.txt
          echo "Built image ID: $IMAGE_ID"
        '''
      }
    }
    stage('Inspect image') {
      steps {
        sh '''
          if command -v docker >/dev/null 2>&1; then D=docker;
          elif [ -x /usr/local/bin/docker ]; then D=/usr/local/bin/docker;
          else D=/opt/homebrew/bin/docker; fi
          $D image inspect "$(cat image_id.txt)" --format 'ID={{.Id}}  SIZE={{.Size}}  TAGS={{join .RepoTags ","}}' || true
        '''
        archiveArtifacts artifacts: 'image_id.txt', fingerprint: true
      }
    }
    stage('Show Dockerfile') {
      steps { sh 'sed -n "1,60p" Dockerfile || true' }
    }
  }
}
