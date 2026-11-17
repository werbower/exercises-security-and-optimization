#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: ./builder.sh <github-repo> <docker-image>"
  exit 1
fi

repoDir="temp_repo"
gitHubRoot="https://github.com"
gitRepo=${1}
if [[ "$gitRepo" != *.git ]]; then
	gitRepo=${gitRepo}.git
fi
gitHubPath=${gitHubRoot}/${gitRepo}

imageTag=${2,,}

#remove repoDir if exist
[ -d "$repoDir" ] && rm -rf "$repoDir"
#path to repo
echo "github path = ${gitHubPath}"
#clone repo to repoDir
git clone "${gitHubPath}" "${repoDir}"
cloneResult=$?
#check if cloned
if [[ $cloneResult -ne 0 ]]; then
	echo " can't clone repo ${gitHubPath}"
	exit 1
fi

#build image
docker build -t "$imageTag" ./"$repoDir"
buldResult=$?	
if [[ $buldResult -ne 0 ]]; then
	echo "
	can't build image"
	exit 1
fi

#push image
docker image push "$imageTag"
pushResult=$?	
if [[ $pushResult -ne 0 ]]; then
	echo "
	can't push image"
	exit 1
fi

#remove dangling images
docker image prune -f
docker rmi -f "$imageTag"










