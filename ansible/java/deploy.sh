#!/bin/bash

export GROUP_NAME=${PROFILE}
#VIS_BUILD_FINAL_DIR='/data/appdata/jenkins/workspace/deploy-trunk-walle-tv-web/walle-tv/walle-tv-web/target'
#VIS_BUILD_FINAL_NAME='walle-tv-web-prerelease-1.2-SNAPSHOT'
#export MODULE_NAME=walle-tv-web
cd ${JENKINS_HOME}/deploy/java/
ansible-playbook -i inventory.py deploy.yml --extra-vars "group_name=${GROUP_NAME} VIS_BUILD_FINAL_DIR=${VIS_BUILD_FINAL_DIR} VIS_BUILD_FINAL_NAME=${VIS_BUILD_FINAL_NAME} MODULE_NAME=${MODULE_NAME} OPERATION=${OPERATION} RUN_REMOTE=${RUN_REMOTE}"
