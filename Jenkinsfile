pipeline {
    agent any

    environment {
        ACR_LOGIN_SERVER = "devopsproject1.azurecr.io"
    }

    options {
        skipDefaultCheckout(true)
    }

    stages {
        stage('Checkout') {
            steps {
                deleteDir()
                git branch: 'main', url: 'https://github.com/devops-project-manisha/Ekart.git'
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
                withCredentials([usernamePassword(
                    credentialsId: 'acr-creds',
                    usernameVariable: 'ACR_USER',
                    passwordVariable: 'ACR_PASS'
                )]) {
                    sh '''
                      echo $ACR_PASS | docker login $ACR_LOGIN_SERVER \
                      -u $ACR_USER --password-stdin
                    '''
                }
            }
        }
    }
}
