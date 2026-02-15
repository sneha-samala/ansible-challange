pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "ap-south-1"
    }

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/sneha-samala/ansible-challange.git',
                    branch: 'main'
            }
        }

        stage('AWS Configure') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_cerds']]) {
                    sh '''
                        mkdir -p ~/.aws
                        echo "[default]" > ~/.aws/credentials
                        echo "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
                        echo "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
                        echo "[default]" > ~/.aws/config
                        echo "region=ap-south-1" >> ~/.aws/config

                        # Validate AWS connection
                        aws sts get-caller-identity
                    '''
                }
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

        stage('Ansible Configure') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'ansible-challenge-key',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    )
                ]) {
                    dir('ansible') {   // fixed path
                        script {
                            def backend_ip = sh(
                                script: "terraform -chdir=../terraform output -raw backend_ip || echo ''",
                                returnStdout: true
                            ).trim()

                            if (!backend_ip) {
                                error "❌ Terraform output 'backend_ip' not found!"
                            } else {
                                echo "✅ Backend IP found: ${backend_ip}"
                            }

                            sh """
                                chmod +x inventories/dynamic_inventory.sh
                                chmod 600 \$SSH_KEY
                                export ANSIBLE_HOST_KEY_CHECKING=False

                                ansible-playbook -i inventories/dynamic_inventory.sh site.yml \
                                    --user=\$SSH_USER \
                                    --private-key=\$SSH_KEY \
                                    --extra-vars "backend_ip=${backend_ip}"
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo '🎉 Pipeline completed successfully without errors!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs above.'
        }
    }
}
