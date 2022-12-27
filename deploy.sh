#! /usr/bin/bash

PROJECT_NAME="merchant"

LOCAL_DIR=`pwd`
BUILD_DIR=$LOCAL_DIR"/build/*"
DEPLOY_SCRIPT="/home/ikbal/project/deploy_to_server.sh"

bash $DEPLOY_SCRIPT -p $PROJECT_NAME -d "$BUILD_DIR"
