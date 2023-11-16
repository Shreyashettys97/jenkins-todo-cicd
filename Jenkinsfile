pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        sh 'docker build -t my-flask-app .'
        sh 'docker tag my-flask-app $DOCKER_BFLASK_IMAGE'
      }
    }
    stages {
      stage('setup') {
         steps {
            browserstack(credentialsId: '1784f7ca-3814-4616-b578-336344d374d5') {
               echo "Testing with Selenium and BrowserStack Platform with Jenkins Provider"
            }
           // Enable reporting in Jenkins
             browserStackReportPublisher 'automate'
         }
      }
    }
    stage('Test') {
      steps {
        sh 'docker run my-flask-app python -m pytest app/tests/'
      }
    }
    stage('Deploy') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKER_REGISTRY_CREDS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
          sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin docker.io"
          sh 'docker push $DOCKER_BFLASK_IMAGE'
        }
      }
    }
  }
  post {
  always {      
      emailext body: 'Check Jenkins-todo-cicd: Build Status', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'DevOps CICD Pipeline in Jenkins'
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}
