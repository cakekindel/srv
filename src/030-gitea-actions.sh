#! /usr/bin/bash

read -rp 'enter action runner token: ' token

cp ./gitea-actions-runner-config.yml /home/git/runner-config.yml

cat << EOF >> /home/git/.env.runner
CONFIG_FILE=/config.yml
GITEA_INSTANCE_URL=https://git.orionkindel.com
GITEA_RUNNER_REGISTRATION_TOKEN=$token
EOF

chown git:git -R /home/git/runner-config.yml
chown git:git -R /home/git/.env.runner
