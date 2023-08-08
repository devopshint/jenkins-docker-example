version: '3.9'

services:
  jenkins:
    build:
      dockerfile: Dockerfile
      context: .
    container_name: jenkins
    restart: always
    privileged: true
    user: root

    healthcheck:
      test: curl -s https://localhost:8080 >/dev/null; if [[ $$? == 52 ]]; then echo 0; else echo 1; fi
      interval: 1m
      timeout: 5s
      retries: 3

    ports:
      - '8080:8080'
    networks:
      - default
    volumes:
      - '/app:/app'
      - '/usr/share/fonts:/usr/share/fonts'
      - '/docker/jenkins/jenkins_home:/var/jenkins_home'
      - '/etc/localtime:/etc/localtime:ro'
      - '/var/run/docker.sock:/var/run/docker.sock'
      - '~/.ssh:/var/jenkins_home/.ssh'
      - '~/.m2:/root/.m2'
networks:
  default:
