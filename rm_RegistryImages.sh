#!/bin/bash
set -x
export HDR='Accept: application/vnd.docker.distribution.manifest.v2+json'export REG_URI='https://docker:docker%40wgj@127.0.0.1:5000/v2'
repository="$1"
function delete_image()
{   for tag in $1; do
    curl -v -k -H "$HDR" -X GET ${REG_URI}/${repository}/manifests/$tag 2>/tmp/mainfest.txt
    MF=`grep Docker-Content-Digest /tmp/mainfest.txt | awk '{print $3}'`
    LEN=${#MF}-1
    MF=${MF:0:$LEN}
    curl -k -H "$HDR" -X DELETE ${REG_URI}/${repository}/manifests/$MF
done
}
# $2 is tag
# if $2 is null then delete all tags of the given repository
if [ -z $2 ]; then
   tag1=$(curl -k ${REG_URI}/$1/tags/list | grep -Po '\[.*\]' | sed 's/,/ /g;s/"//g;s/\[//g;s/\]//g')
  delete_image "$tag1"
else
 delete_image $2
fi
