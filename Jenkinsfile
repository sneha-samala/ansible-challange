pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Generate Inventory') {
            steps {
                dir('terraform') {
                    script {
                        def amazon_ip = sh(script: "terraform output -raw amazon_ip", returnStdout: true).trim()
                        def ubuntu_ip = sh(script: "terraform output -raw ubuntu_ip", returnStdout: true).trim()

                        writeFile file: "../ansible/inventory", text: """
[amazon]
${amazon_ip} ansible_user=ec2-user

[ubuntu]
${ubuntu_ip} ansible_user=ubuntu
"""
                    }
                }
            }
        }

        stage('Ansible Deploy') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook -i inventory configure.yml'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully 🎉'
        }
        failure {
            echo 'Pipeline failed ❌'
        }
    }
}
