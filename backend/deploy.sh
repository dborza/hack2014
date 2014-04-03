#!/bin/sh

#
#   Script for downloading, compiling and deploying the app. Simple and efficient.
#
git pull
mvn clean install package
java -jar target/gs-accessing-data-rest-0.1.0.jar