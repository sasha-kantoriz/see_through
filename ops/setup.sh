#!/bin/bash

HOME_DIR=$1

DEPLOY_DIR="$HOME_DIR/deploy"
PACKAGED_APP="$DEPLOY_DIR/$2"
TEMP_DIR="$DEPLOY_DIR/temp"
unzip -o $PACKAGED_APP -d $TEMP_DIR -x "setup.sh" 1>/dev/null 2>&1

echo "Staging a Vagrant box ..."
if [ ! -f $HOME_DIR/Vagrantfile ]; then
    vagrant init ubuntu/trusty32   
fi



# cp /home/ubuntu/box/deploy/temp/Vagrantfile box/

echo "Done."