pipeline {
    agent any
    parameters {
        string(name: 'ENV', defaultValue: 'local', description: 'Environment to deploy to')
        string(name: 'KUBECONFIG_PATH', defaultValue: '~/.kube/config', description: 'Path to kubeconfig file')
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Docker image tag')
    }
    environment {
        APP_NAME = "localhost/springbootrest"
        CHART_PATH = "./helm/springbootrest" // Relative path to the local Helm chart
    }
    stages {
        stage('Build') {
            steps {
                echo "Building the application using Maven..."
                sh './mvnw clean package'
            }
        }
        stage('Docker Build & Load') {
            steps {
                echo "Building Docker image and loading it into Minikube..."
                sh """
                docker build -t ${APP_NAME}:${IMAGE_TAG} .
                minikube image load ${APP_NAME}:${IMAGE_TAG}
                """
            }
        }
        stage('Docker Build & Load') {
            steps {
                echo "Delete old helm release if available"
                sh """
                helm uninstall ${APP_NAME} | true
                """
            }
        }
        stage('Terraform Init') {
            steps {
                echo "Initializing Terraform..."
                sh """
                cd terraform
                terraform init
                """
            }
        }
        stage('Terraform Plan') {
            steps {
                echo "Running Terraform plan..."
                sh """
                cd terraform
                terraform plan \
                  -var "name=${APP_NAME}" \
                  -var "image=${APP_NAME}:${IMAGE_TAG}" \
                  -var "kubeconfig_path=${KUBECONFIG_PATH}"
                """
            }
        }
        stage('Terraform Apply') {
            steps {
                echo "Applying Terraform changes..."
                sh """
                cd terraform
                terraform apply -auto-approve \
                  -var "name=${APP_NAME}" \
                  -var "image=${APP_NAME}:${IMAGE_TAG}" \
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