pipeline {
  agent any

  options {
    timestamps()
  }

  environment {
    KUBECTL_VERSION = "v1.29.0"
    PATH = "${env.WORKSPACE}/bin:${env.PATH}"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install kubectl (local)') {
      steps {
        sh '''
          mkdir -p bin
          curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
          chmod +x kubectl
          mv kubectl bin/kubectl
          kubectl version --client
        '''
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

