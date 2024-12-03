pipeline {
    agent any
    parameters {
        string(name: 'ENV', defaultValue: 'local', description: 'Environment to deploy to')
        string(name: 'KUBECONFIG_PATH', defaultValue: '/root/.kube/config', description: 'Path to kubeconfig file')
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Docker image tag')
        string(name: 'NAMESPACE', defaultValue: 'default', description: 'Kubernetes namespace')
    }
    environment {
        APP_NAME = "springbootrest"
        CHART = "springbootrest"
        CHART_VERSION = "1.0.0"
        HELM_REPO_URL = "https://charts.bitnami.com/bitnami"
    }
    stages {
        stage('Build') {
            steps {
                sh './mvnw clean package'
            }
        }
        stage('Docker Build & Push') {
            steps {
                sh """
                docker build -t ${APP_NAME}:${IMAGE_TAG} .
                docker push ${APP_NAME}:${IMAGE_TAG}
                """
            }
        }
        stage('Terraform Init') {
            steps {
                sh """
                cd terraform
                terraform init
                """
            }
        }
        stage('Terraform Plan') {
            steps {
                sh """
                cd terraform
                terraform plan \
                  -var "name=${APP_NAME}" \
                  -var "namespace=${NAMESPACE}" \
                  -var "image=${APP_NAME}:${IMAGE_TAG}" \
                  -var "chart=${CHART}" \
                  -var "chart_version=${CHART_VERSION}" \
                  -var "helm_repo_url=${HELM_REPO_URL}" \
                  -var "kubeconfig_path=${KUBECONFIG_PATH}"
                """
            }
        }
        stage('Terraform Apply') {
            steps {
                sh """
                cd terraform
                terraform apply -auto-approve \
                  -var "name=${APP_NAME}" \
                  -var "namespace=${NAMESPACE}" \
                  -var "image=your-docker-repo/${APP_NAME}:${IMAGE_TAG}" \
                  -var "chart=${CHART}" \
                  -var "chart_version=${CHART_VERSION}" \
                  -var "helm_repo_url=${HELM_REPO_URL}" \
                  -var "kubeconfig_path=${KUBECONFIG_PATH}"
                """
            }
        }
    }
    post {
        success {
            echo "Deployment completed successfully!"
        }
        failure {
            echo "Deployment failed. Please check the logs."
        }
    }
}