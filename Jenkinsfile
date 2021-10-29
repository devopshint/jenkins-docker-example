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
        
    // stage('Building our image') { 
           // steps { 
               // script {
                  //  sh 'docker build -f Dockerfile -t my-app .'
                    //dockerImage = docker.build registry + ":$BUILD_NUMBER" 
              //  }
          //  } 
      //  }
    }
}
