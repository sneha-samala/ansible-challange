pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {

        stage('Checkout Code') {
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

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
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
                    sh '''
                    AMAZON_IP=$(terraform output -raw amazon_ip)
                    UBUNTU_IP=$(terraform output -raw ubuntu_ip)

                    echo "[amazon]" > ../ansible/inventory
                    echo "$AMAZON_IP ansible_user=ec2-user" >> ../ansible/inventory
                    echo "" >> ../ansible/inventory
                    echo "[ubuntu]" >> ../ansible/inventory
                    echo "$UBUNTU_IP ansible_user=ubuntu" >> ../ansible/inventory
                    '''
                }
            }
        }

        stage('Run Ansible') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook -i inventory configure.yml'
                }
            }
        }
    }

    post {
        success {
            echo "Deployment Successful 🎉"
        }
        failure {
            echo "Deployment Failed ❌"
        }
    }
}
