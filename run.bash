#!/bin/bash
# Run below step one by one in terminal
sudo docker rmi -f $(sudo docker images -f "dangling=true" -q)
docker build -t lora_convert .
docker run --net host --gpus all -it -v /media/beastan/projects/deploy_to_ollama:/app lora_convert


