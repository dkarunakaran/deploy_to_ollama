#!/bin/bash

if [ "$1" ]; then
  echo "base_model_name location provided"
else
  echo "No base_model_name location  provided. For example, something.gguf"
  exit
fi

if [ "$1" ]; then
  echo "lora_model_name location provided"
else
  echo "No lora_model_name location  provided. For example, something.gguf"
  exit
fi

if [ "$1" ]; then
  echo "combined_model_name location provided"
else
  echo "No combined_model_name location  provided. For example, something.gguf"
  exit
fi

if [ "$1" ]; then
  echo "ollama_custom_model_loc location provided"
else
  echo "No ollama_custom_model_loc location  provided"
  exit
fi

if [ "$1" ]; then
  echo "ollama_model_name location provided"
else
  echo "No ollama_model_name location  provided"
  exit
fi


# Download all the gguf model to the $ollama_custom_model_loc/$ollama_model_name

git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
cmake -B build
cmake --build build --config Release

cd build/bin

base_model_name=$1
lora_model_name=$2
combined_model_name=$3
ollama_custom_model_loc=$4
ollama_model_name=$5

mkdir -p $ollama_custom_model_loc/$ollama_model_name

bash ./llama-export-lora \
    -m $ollama_custom_model_loc/$ollama_model_name/$base_model_name \
    -o $ollama_custom_model_loc/$ollama_model_name/$combined_model_name \
    --lora $ollama_custom_model_loc/$ollama_model_name/$lora_model_name


cd $ollama_custom_model_loc/$ollama_model_name

touch Modelfile

echo "from $combined_model" >> Modelfile

ollama create $ollama_model_name -f Modelfile

ollama run $ollama_model_name