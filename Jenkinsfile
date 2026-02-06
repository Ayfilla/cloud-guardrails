pipeline {
  agent any

  options {
    timestamps()
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install Gatekeeper (idempotent)') {
      steps {
        sh '''
          kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.14/deploy/gatekeeper.yaml
        '''
      }
    }

    stage('Apply Gatekeeper Policies') {
      steps {
        sh '''
          kubectl apply -f 01-eks-gatekeeper/policies/
        '''
      }
    }

    stage('Policy Enforcement Test (expected failure)') {
      steps {
        script {
          int status = sh(
            script: 'kubectl apply -f 01-eks-gatekeeper/tests/bad-pod.yaml',
            returnStatus: true
          )

          if (status == 0) {
            error("❌ Guardrail FAILED: bad pod was NOT blocked")
          } else {
            echo("✅ Guardrail OK: bad pod correctly blocked")
          }
        }
      }
    }

    stage('Positive Control (good resource)') {
      steps {
        sh '''
          kubectl apply -f 01-eks-gatekeeper/tests/good-deployment.yaml
        '''
      }
    }
  }

  post {
    success {
      echo '🎉 PIPELINE SUCCESS — Guardrails enforced correctly'
    }
    failure {
      echo '❌ PIPELINE FAILED — Guardrails broken'
    }
    always {
      cleanWs()
    }
  }
}

