#!/bin/bash

export JENKINS_DIR=/data/jenkins
export JENKINS_HOME=/data/jenkins/data
export HTTP_PORT=18080

cd $JENKINS_DIR/scripts
java -jar $JENKINS_DIR/binary/jenkins.war --httpPort=$HTTP_PORT
