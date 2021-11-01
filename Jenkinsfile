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
         sh"/opt/maven/bin/mvn clean package "
}
}
stage("build & SonarQube analysis") {
           
            steps {
              withSonarQubeEnv('sonar') {
                sh '/opt/maven/bin/mvn sonar:sonar'
              }
            }
          }
          //stage("Quality Gate") {
            //steps {
              //timeout(time: 1, unit: 'MINUTES') {
                //waitForQualityGate abortPipeline: true
              //}
            //}
        //}


        stage("testing") {
                when {
                   branch 'QA'
                }
                steps {

                      sh '/opt/maven/bin/mvn cobertura:cobertura -Pmetrics -Dcobertura.report.format=xml'
                     cobertura autoUpdateHealth: false, autoUpdateStability: false, coberturaReportFile: '**/target/site/cobertura/coverage.xml', conditionalCoverageTargets: '70, 0, 0', enableNewApi: true, failNoReports: false, failUnhealthy: false, failUnstable: false, lineCoverageTargets: '80, 0, 0', maxNumberOfBuilds: 0, methodCoverageTargets: '80, 0, 0', onlyStable: false, sourceEncoding: 'ASCII', zoomCoverageChart: false   
                     sh '/opt/maven/bin/mvn verify'
                     junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
                }
        }
       stage ('Notify Dev'){     
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
         stage ('Notify qa'){     
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
           stage ('Notify Dev again'){     
           steps {
              slackSend baseUrl: 'https://hooks.slack.com/services/', channel: 'jenkins_dev', message: 'Your Deployment is completed :-)', teamDomain: '$WORKSPACE', tokenCredentialId: 'slack', username: 'Akash'
                 }
    }    
       stage ('Notify qa again'){ 
              when {
                   branch 'QA'
                }
              steps {
                 slackSend baseUrl: 'https://hooks.slack.com/services/', channel: 'jenkins_qa', message: 'Your Deployment is successfully completed !!', teamDomain: '$WORKSPACE', tokenCredentialId: 'slackqa', username: 'Akash'
                 }
    }
       stage ('email notification'){     
           steps {
                         
               emailext body: '''Hello Dev Team 
               Your deployment is successful !! ${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}''', subject: 'Jenkins Job status', to: 'snarang601@gmail.com'

           }
    }    
    
    }
}
