pipeline {
    agent any

    environment {
        // Replace 'aws-creds' with the ID of your Jenkins AWS credentials
        AWS_ACCESS_KEY_ID     = credentials('aws-creds')
        AWS_SECRET_ACCESS_KEY = credentials('aws-creds')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {

        stage('Checkout SCM') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/sneha-samala/ansible-challange.git'
                    ]]
                ])
            }
        }

        stage('Terraform Init') {
            steps {
                dir('ci-pipeline/terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('ci-pipeline/terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('ci-pipeline/terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('ci-pipeline/terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Fetch Terraform Output') {
            steps {
                dir('ci-pipeline/terraform') {
                    sh 'terraform output -raw ansible_inventory > ../ansible/inventory.ini'
                }
            }
        }

        stage('Ansible Configure') {
            steps {
                dir('ci-pipeline/ansible') {
                    sh 'ansible-playbook -i ../ansible/inventory.ini playbook.yml'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check console logs.'
        }
    }
}
