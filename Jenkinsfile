pipeline {
       // environment { 
        //registry = "akash64574/myapp" 
        //registryCredential = 'dockerhub' 
        //dockerImage = '' 
   // }
agent any

stages {

stage('SCM Checkout') {
        steps {
                checkout scm
          //  git 'https://github.com/akash64574/maven-hello-world'
}
}

stage('Build') {
steps {
         sh"/opt/maven/bin/mvn clean package -Dmaven.test.skip=true"
}
}
stage("build & SonarQube analysis") {
           
            steps {
              withSonarQubeEnv('sonar') {
                sh '/opt/maven/bin/mvn sonar:sonar'
              }
            }
          }
       post {
        always {
            emailext body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Test'
        }
       }

        stage("testing") {
                when {
                   branch 'QA'
                }
                steps {
                    sh 'echo hello' 
                }
        }
    stage('Build Docker Image') {
            steps {
                script {
                  sh 'docker build -t akash64574/my-app-1.0 .'
                }
            }
        }
            stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]) {
                         sh 'docker login -u akash64574 -p ${dockerhubpwd}'
    }
                sh 'docker push akash64574/my-app-1.0'
                }
            }
        }    
    
    }
}
