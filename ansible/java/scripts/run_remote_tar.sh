#!/bin/bash

MODULE=${1}
ARTIFACT=${2}
RUNARG=${3}

cd /data/vrsapps/${MODULE}
echo `pwd`
ARTIFACT_FILE="${ARTIFACT}.tar.gz"
if [ ! -f $ARTIFACT_FILE ];then
    echo "$ARTIFACT_FILE not exist"
    exit 1     
fi
if [ -e app ];then
    LINK_NAME=`readlink app`
    echo $LINK_NAME
    ARCHIVE_FILE="${LINK_NAME}.`date +"%Y%m%d%H%M%S"`.tar.gz"
    tar -czf ${ARCHIVE_FILE} ${LINK_NAME}
    if [ -e "last-archive" ];then
        rm last-archive
    fi
    ln -sf ${ARCHIVE_FILE} last-archive
    rm -rf ${LINK_NAME}
    rm -rf app
fi
tar -xzf $ARTIFACT_FILE
ln -sf ${ARTIFACT} app
bash -ex app/bin/run.sh ${RUNARG}

if [ -z "`grep '/${MODULE}/' /etc/rc.local`" ];then
    echo "bash /data/vrsapps/${MODULE}/app/bin/run.sh ${RUNARG}" >> /etc/rc.local
fi

