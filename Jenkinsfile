pipeline {
  agent any

  stages {
    stage('Build image') {
      steps {
        echo 'Checking out code...'
      	sh(script: """ whoami;pwd;ls -la """, label: "first step")
      }
    }
  }
}
