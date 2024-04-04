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
    CHANGE_OWNER_SYSTEMD = "sudo chown +x /lib/systemd/system/${APP_NAME}.service"
  }

  stages {
    stage('Systemd') {
      steps {
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
    }
  }
}
