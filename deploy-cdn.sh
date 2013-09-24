#!/bin/bash


USERNAME=jonaa
HOST=hi7dev.huygens.knaw.nl
DEPLOY_DIR=/data/cdn/elaborate/

TAG=$1
SERVER=$USERNAME@$HOST
TEMP=/tmp
TARBALL=$TAG.tgz
TEMP_TGZ=$TEMP/$TARBALL
CLEAR_DIR_CMD="rm -rf $DEPLOY_DIR/$TAG/*"

cd dist
echo "Creating archive for tag $TAG..."
git archive --format=tar --prefix=$TAG/ $TAG . | gzip -9c > $TEMP_TGZ

echo "Transferring archive to $SERVER"
scp $TEMP_TGZ $SERVER:/tmp

# If already exists, empty tag dir, then unpack; remove tarball
echo "Unpacking archive in $DEPLOY_DIR..."
ssh -t $SERVER "if [ -d $DEPLOY_DIR/$TAG ]; then $CLEAR_DIR_CMD; fi; tar zxf $TEMP_TGZ -C $DEPLOY_DIR; rm /tmp/$TARBALL"

echo "Done!"
