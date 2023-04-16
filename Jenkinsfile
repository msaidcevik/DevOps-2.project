pipeline {
    agent any
    environment {
        PATH=sh(script:"echo $PATH:/usr/local/bin", returnStdout:true).trim()
        AWS_REGION = "us-east-1"
        AWS_ACCOUNT_ID=sh(script:'export PATH="$PATH:/usr/local/bin" && aws sts get-caller-identity --query Account --output text', returnStdout:true).trim()
        ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        APP_REPO_NAME = "kittens/apache"
        CLUSTER_NAME = "kittens"
    }
    stages {
        
        stage('Checkout Github') {
            steps {
                git credentialsId: '8ec03176-3d0a-4b0c-8041-ec147d4569b9', url: 'https://github.com/msaidcevik/demo1.git'
            }
        }
        
        stage('Create ECR Repo') {
            steps {
                echo 'Creating ECR Repo for App'
                sh """
                aws ecr create-repository \
                  --repository-name ${APP_REPO_NAME} \
                  --image-scanning-configuration scanOnPush=false \
                  --image-tag-mutability MUTABLE \
                  --region ${AWS_REGION}
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build --force-rm -t "$ECR_REGISTRY/$APP_REPO_NAME:latest" .'
                sh 'docker image ls'
            }
        }

        stage('Push Image to ECR Repo') {
            steps {
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$ECR_REGISTRY"'
                sh 'docker push "$ECR_REGISTRY/$APP_REPO_NAME:latest"'
            }
        }

        stage('Create ECS cluster') {
            steps {
                sh 'aws ecs create-cluster --cluster-name ${CLUSTER_NAME}-cluster'
            }
        }

        stage('Register Task definition') {
            steps {
                sh "aws ecs register-task-definition --cli-input-json file://kittens-task.json"
            }
        }    
        
        stage('Create Service') {
            steps {
                sh '''aws ecs create-service --cluster kittens-cluster \\
                        --service-name kittens-service \\
                        --task-definition kittens-task \\
                        --desired-count 1 --launch-type "FARGATE" \\
                        --network-configuration "awsvpcConfiguration={subnets=[subnet-0a57290a9d51f677e],securityGroups=[sg-0505b0d6ccac33870],assignPublicIp=ENABLED}"
                    '''
            }
        }
    }
}    