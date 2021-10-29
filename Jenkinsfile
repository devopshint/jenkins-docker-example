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
      

        stage("testing") {
                when {
                   branch 'QA'
                }
                steps {
                    sh 'echo hello' 
                }
        }
       stage ('Notify'){     
        steps {
            slackSend baseUrl: 'https://hooks.slack.com/services/', channel: 'jenkins_dev', message: 'Build and Testing completed  Deployment is under process , please wait for further notification ', teamDomain: '$WORKSPACE', tokenCredentialId: 'slack', username: 'Akash'
                 }
    }
    stage('Build Docker Image') {
            steps {
                script {
                  sh 'docker build -t akash64574/my-app-1.0 .'
                }
            }
        }
         stage ('Notify'){     
        steps {
            slackSend baseUrl: 'https://hooks.slack.com/services/', channel: 'jenkins_qa', message: 'Build and Testing completed and status is good , Deployment is pending for approval', teamDomain: '$WORKSPACE', tokenCredentialId: 'slackqa', username: 'Akash'
                 }
    }
         stage( 'Appoval mail for QA' ){
            steps{
                slackSend baseUrl: 'https://hooks.slack.com/services/', channel: 'jenkins_qa', message: "${env.BUILD_URL}", teamDomain: '', tokenCredentialId: 'slackqa'
        }
}
            
        stage("QA Approval") {
                  steps {
     
script {
def userInput = input(id: 'Proceed1', message: 'Promote build?', parameters: [[$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Please confirm you agree with this']])
echo 'userInput: ' + userInput
 
            if(userInput == true) {
                // do action
            } else {
                // not do action
                echo "Action was aborted."
            }
 
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
