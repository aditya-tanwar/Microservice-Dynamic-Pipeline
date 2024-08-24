#!/bin/bash



nexus_url=$1
appversion=$2
components=$(cat components) 



for i in $components;
do
  echo $i 
  sed -i "s|image: .*|image: $nexus_url/$i-$(date +'%F'):v$appversion|g" k8s/$i/deployment.yaml
  ((i++)) 
done

exit 0
