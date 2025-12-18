pipeline {
    agent any

    environment {
        ACR_LOGIN_SERVER = "devopsproject1.azurecr.io"
        IMAGE_NAME = "ekartshopping"
        TAG = "latest"
    }

    options {
        skipDefaultCheckout(true)
    }

    stages {

        stage('Checkout') {
            steps {
                deleteDir()
                git branch: 'main',
                    url: 'https://github.com/devops-project-manisha/Ekart.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan pom.xml',
                                odcInstallation: 'Dependency-Check'

                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('Building image') {
            steps {
                sh 'docker build -t ekartshopping:latest .'
            }
        }

        stage('Login to ACR') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'acr-creds',
                        usernameVariable: 'ACR_USER',
                        passwordVariable: 'ACR_PASS'
                    )
                ]) {
                    sh '''
                      echo $ACR_PASS | docker login $ACR_LOGIN_SERVER \
                      -u $ACR_USER --password-stdin
                    '''
                }
            }
        }

        stage('Tag Image') {
            steps {
                sh '''
                  docker tag ${IMAGE_NAME}:${TAG} \
                  $ACR_LOGIN_SERVER/${IMAGE_NAME}:${TAG}
                '''
            }
        }

        stage('Push Image to ACR') {
            steps {
                sh 'docker push $ACR_LOGIN_SERVER/${IMAGE_NAME}:${TAG}'
            }
        }

        stage('Deploy the docker image to QA server') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'acr-creds',
                        usernameVariable: 'ACR_USER',
                        passwordVariable: 'ACR_PASS'
                    )
                ]) {
                    sh """
                      ssh jenkins@4.222.234.133 \\
                      'ansible-playbook /home/jenkins/Myansible/ekart-1.yml \\
                      -e acr_username=$ACR_USER \\
                      -e acr_password=$ACR_PASS \\
                      -b'
                    """
                }
            }
        }

        stage('Deploying to Kubernetes') {
            steps {
                sh '''
                  kubectl apply -f deploymentservice.yml
                  kubectl apply -f service.yml
                '''
            }
        }

    }
}
