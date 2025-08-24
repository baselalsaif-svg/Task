pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build image (no tag)') {
      steps {
        sh '''
          set -e
          # Build without specifying an image name/tag; capture the resulting image ID
          IMAGE_ID=$(docker build -q .)
          echo "$IMAGE_ID" | tee image_id.txt
          echo "Built image ID: $IMAGE_ID"
        '''
      }
    }
    stage('Show result') {
      steps {
        sh '''
          echo "Saved image ID:"
          cat image_id.txt
          echo
          echo "Inspecting image:"
          docker image inspect "$(cat image_id.txt)" \
            --format 'ID={{.Id}}  SIZE={{.Size}}  TAGS={{join .RepoTags ","}}' || true
        '''
        archiveArtifacts artifacts: 'image_id.txt', fingerprint: true
      }
    }
    // Optional: quick peek at your Dockerfile for sanity
    stage('Show Dockerfile (optional)') {
      steps { sh 'sed -n "1,60p" Dockerfile || true' }
    }
  }
}

