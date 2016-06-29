#!/bin/bash

set -x
set -e

sudo docker kill stack_all || true
sudo docker rm stack_all || true
sudo docker build -t rlpowell/stack .
sudo docker run -it --name stack_all --volumes-from stackstore -p 0.0.0.0:8081:8081 rlpowell/stack /home/rlpowell/stack/stack_all_internal.sh
