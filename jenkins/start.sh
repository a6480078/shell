#!/bin/bash

nohup java -jar /opt/jenkins/jenkins.war --ajp13Port=-1 --httpPort=8888 &
