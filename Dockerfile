FROM openjdk
COPY target/*.jar .
EXPOSE 9000
ENTRYPOINT ["java","-cp","/my-app-1.0-SNAPSHOT.jar","com.mycompany.app.App"]
