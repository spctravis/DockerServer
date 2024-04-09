#!/bin/bash

git clone https://github.com/mattermost/docker
cd docker


mkdir -p ./volumes/app/mattermost/{config,data,logs,plugins,client/plugins,bleve-indexes}
sudo chown -R 2000:2000 ./volumes/app/mattermost

bash scripts/issue-certificate.sh -d chat.badger.lan -o ${PWD}/certs

