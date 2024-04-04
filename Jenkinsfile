pipeline {
  agent any

  environment {
    APP_NAME = 'postgresql-python'
    APP_PORT = 8000
    PROCESS_NAME = "${APP_NAME}.service"
    COPY_SYSTEMD_FILE = "sudo cp ${APP_NAME}.service /lib/systemd/system/"
    RELOAD_SYSTEMD = "sudo systemctl daemon-reload"
    KILL_ALL_PORT = "sudo fuser -k ${APP_PORT}/tcp || true"
    RUN_WITH_SYSTEMD = "sudo systemctl start ${PROCESS_NAME}"
    STOP_WITH_SYSTEMD = "sudo systemctl stop ${PROCESS_NAME}"
    CHECK_STATUS_SYSTEMD = "sudo systemctl status ${PROCESS_NAME}"
    CHANGE_OWNER_SYSTEMD = "sudo chmod +x /lib/systemd/system/${APP_NAME}.service"
  }

  stages {
    stage('Systemd') {
      steps {
        script {
          try {
            timeout(time: 5, unit: 'MINUTES') {
              env.useChoice = input message: "Do you want to continue with systemd or docker",
                  parameters: [choice(name: 'Deploy', choices: 'systemd\ndocker\nno', description: 'Choose one')],
            }
            if (env.useChoice == 'systemd') {
              echo 'Checking out code...'
              sh(script: """ whoami;pwd;ls -la """, label: "first step")
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
              sh(script: """ whoami;pwd;ls -la """, label: "first step")
              sh(script: """ docker-compose down """, label: "docker-compose down")
              sh(script: """ docker-compose up -d """, label: "docker-compose up")
              sleep(time: 10, unit: 'SECONDS')
              sh(script: """ docker ps """, label: "docker ps")
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
}
