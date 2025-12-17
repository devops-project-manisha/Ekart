pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/devops-project-manisha/Ekart.git'
            }
        }

        stage('Building the image') {
            steps {
                sh 'mvn clean package'
            }
        }
    }
}
