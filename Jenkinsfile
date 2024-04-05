pipeline {
  agent any

  environment {
    APP_NAME = 'postgresql-python'
    APP_PORT = 8000
    DOCKERHUB_CREDENTIALS= credentials('dockerhubcredentials')
    DOCKER_BUILD_IMAGE_NAME = "${DOCKERHUB_CREDENTIALS_USR}/${APP_NAME}:${BUILD_NUMBER}"
    PROCESS_NAME = "${APP_NAME}.service"
    CHECK_CURRENT_STATE = "whoami;pwd;ls -la"
    COPY_SYSTEMD_FILE = "sudo cp ${APP_NAME}.service /lib/systemd/system/"
    RELOAD_SYSTEMD = "sudo systemctl daemon-reload"
    KILL_ALL_PORT = "sudo fuser -k ${APP_PORT}/tcp || true"
    RUN_WITH_SYSTEMD = "sudo systemctl start ${PROCESS_NAME}"
    STOP_WITH_SYSTEMD = "sudo systemctl stop ${PROCESS_NAME}"
    CHECK_STATUS_SYSTEMD = "sudo systemctl status ${PROCESS_NAME}"
    CHANGE_OWNER_SYSTEMD = "sudo chmod +x /lib/systemd/system/${APP_NAME}.service"
    DOCKER_BUILD_IMAGE = "docker build -t ${DOCKER_BUILD_IMAGE_NAME} ."
    DOCKER_PUSH_IMAGE = "sudo docker push ${DOCKER_BUILD_IMAGE_NAME}"
    DOCKER_LOGOUT = "docker logout"
  }

  stages {
    stage('Deploy') {
      steps {
        script {
          try {
            timeout(time: 5, unit: 'MINUTES') {
              env.useChoice = input message: "Do you want to continue with systemd or docker",
                  parameters: [choice(name: 'Deploy', choices: 'systemd\ndocker\nno', description: 'Choose one')]
            }
            if (env.useChoice == 'systemd') {
              echo 'Checking out code...'
              sh(script: """ ${CHECK_CURRENT_STATE} """, label: "check current state")
              sh(script: """ ${CHANGE_OWNER_SYSTEMD} """, label: "change owner")
              sh(script: """ ${COPY_SYSTEMD_FILE} """, label: "copy systemd file")
              sh(script: """ ${KILL_ALL_PORT} """, label: "kill all process on port ${APP_PORT}")
              sh(script: """ ${RELOAD_SYSTEMD} """, label: "reload systemd")
              sh(script: """ ${STOP_WITH_SYSTEMD} """, label: "stop application with systemd")
              sh(script: """ ${RUN_WITH_SYSTEMD} """, label: "run application with systemd")
              sleep(time: 10, unit: 'SECONDS')
              sh(script: """ ${CHECK_STATUS_SYSTEMD} """, label: "check status of systemd")
            }
            else if (env.useChoice == 'docker') {
              echo 'Checking out code...'
              sh(script: """ ${CHECK_CURRENT_STATE} """, label: "check current state")
              sh(script: """ sudo usermod -aG docker \$(whoami) """, label: "add user to group docker")
              sh(script: """ ${DOCKER_BUILD_IMAGE} """, label: "build docker image")
              sh(script: """ echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} -p ${DOCKERHUB_CREDENTIALS_PSW} """, label: "login to dockerhub")
            }
            else {
              echo 'No deployment'
            }
          } catch (Exception e) {
            echo 'Error: ${e}'
          }
        }
      }
    }
  }
  post{
    always {
      sh(script: """ ${DOCKER_LOGOUT} """, label: "logout from dockerhub")
    }
  }
}
