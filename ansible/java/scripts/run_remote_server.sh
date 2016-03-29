#!/bin/bash

MODULE=${1}
ARTIFACT=${2}
RUNARG=${3}

cd /data/vrsapps/${MODULE}
ARTIFACT_NAME="${ARTIFACT}"
ARTIFACT_FILE="${ARTIFACT_NAME}.war"

if [ ! -f "$ARTIFACT_FILE" ];then
    echo "$ARTIFACT_FILE not exist"
    exit 1     
fi

if [ -e app ];then
    LINK_NAME=`readlink app`
    echo $LINK_NAME
    ARCHIVE_FILE="${LINK_NAME}.`date +"%Y%m%d%H%M%S"`.war"
    jar -cf ${ARCHIVE_FILE} ${LINK_NAME}
    if [ -e "last-archive" ];then
        rm -f last-archive
    fi
    ln -sf ${ARCHIVE_FILE} last-archive
    rm -rf ${LINK_NAME}
    rm -rf app
fi

unzip -q $ARTIFACT_FILE -d $ARTIFACT_NAME
ln -sf $ARTIFACT_NAME app

if [ -d "/data/apps/jetty" ];then
    bash /data/apps/jetty/bin/jetty.sh restart >/dev/null 2>&1
elif [ -d "/data/apps/resin-4.0.36" ];then 
    bash /data/apps/resin-4.0.36/bin/resin.sh restart
else
    echo "no available server found."
    exit 1
fi
