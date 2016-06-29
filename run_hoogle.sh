#!/bin/bash

sudo docker kill stack_all_hoogle || true
sudo docker rm stack_all_hoogle || true
sudo docker run --name stack_all_hoogle --volumes-from stackstore -p 0.0.0.0:8081:8081 -d rlpowell/stack \
  /home/rlpowell/.local/bin/hoogle server --local -p 8081 --host '*'
