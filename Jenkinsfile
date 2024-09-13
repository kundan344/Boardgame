pipeline {
    agent any
    
    tools {
        jdk 'java17'
        maven 'maven3'
    }
    
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/kundan344/Boardgame.git'
            }
        }
        
        stage('Code Compile') {
            steps {
                sh "mvn compile"
            }
        }
        
        stage('Parallel Testing and Scanning') {
            parallel {
                stage('Code Test') {
                    steps {
                        sh "mvn test"
                    }
                }
        
                stage('Trivy FS Scan') {
                    steps {
                        sh "trivy fs --format table -o trivy-fs-scan-report.xml ."
                    }
                }
        
                stage('Sonar Code Analysis') {
                    steps {
                        withSonarQubeEnv('sonar-server') {
                            sh """
                            $SCANNER_HOME/bin/sonar-scanner \
                            -Dsonar.projectName=Boardgame \
                            -Dsonar.projectKey=Boardgame \
                            -Dsonar.java.binaries=target/classes
                            """
                        }
                    }
                }
                
            }
        }
        
        stage('Build Artifact') {
            steps {
                sh "mvn package"
            }
        }
        
        stage('Docker Image Build & Push') {
                    steps {
                        script {
                         withDockerRegistry(credentialsId: 'docker-cred') {
                              sh "docker build -t boardgame ."
                              sh "docker tag boardgame kundankumar344/boardgame:latest"
                              sh "docker push kundankumar344/boardgame:latest"
                              sh "docker rmi -f kundankumar344/boardgame:latest"
                        }   
                            
                            
                        }
                    }
                }
    }

    post {
        
        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
