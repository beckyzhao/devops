MODULE_NAME=${1}
RUN_ARG='${2}'
cd /data/vrsapps/${MODULE_NAME}

if [ ! -e "last-archive" ];then
    echo "last archive no exist."
    echo "last archive no exist.">1
    exit        
fi

if [ -e app ];then
    LINK_NAME=`readlink app`
    rm -rf ${LINK_NAME}
    rm -rf app
fi

ARCHIVE_FILE=`readlink last-archive`
ARTIFACT=`echo ${ARCHIVE_FILE} | sed -e 's/.[0-9]\{14\}.tar.gz//g'`

tar -xzf "last-archive"
ln -sf ${ARTIFACT} app
bash -ex app/bin/run.sh ${RUN_ARG}
