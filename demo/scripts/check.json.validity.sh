#!/bin/sh 

#Checks validity of files with json extensions.
#Firs command line argument is the path of the folder the check should be done on
find $1 -type f -name "*.json" -exec sh -c "echo {} | jsonlint-php {}" \;

