
# Deploying to Ollama

The information below outlines the manual steps needed to deploy a fine-tuned model to Ollama.

## Steps

**1. Preparation**

* Train a LORA adapter. For example the train the model for invoice
* Ensure the quantization (e.g., Q8) used in the LORA adapters are available in the conversion(second step) option.

**2. Conversion to GGUF format**

* Convert both the base model and the LORA adapter to GGUF format using the Hugging Face conversion tool ([https://github.com/ggerganov/llama.cpp/discussions/2948](https://github.com/ggerganov/llama.cpp/discussions/2948)).
    * **Base Model:** [https://huggingface.co/spaces/ggml-org/gguf-my-repo](https://huggingface.co/spaces/ggml-org/gguf-my-repo)
    * **LORA Adapter:** [https://huggingface.co/spaces/ggml-org/gguf-my-lora](https://huggingface.co/spaces/ggml-org/gguf-my-lora)
    * Some time above LORA Adapter link may not work. In that case, we can clone the llama.cpp by following the step no.3,
        then run the the below step to get into the container
        ```
        bash run.bash
        ```
        Then cd to llama.cpp in the container, then run `pip install -r requirements.txt` which will install all the neceassry library for the converrsion in the container. Then run below code to convert the LORA adapters.
        ```
        python convert_lora_to_gguf.py models/llama-3.2-3B-instruct-q8-invoice --outfile models/llama-3.2-3B-instruct-q8-invoice/llama-3.2-3B-instruct-q8-invoice.gguf --outtype q8_0
        ```

* Download the converted GGUF files to a suitable directory within a newly created repository under your username.

**3. Building Llama.cpp**

* Clone and build the Llama.cpp library from GitHub: [https://github.com/ggerganov/llama.cpp](https://github.com/ggerganov/llama.cpp)
    * Open a terminal or command prompt.
    * Run the following commands step-by-step:
        ```bash
        git clone [https://github.com/ggerganov/llama.cpp](https://github.com/ggerganov/llama.cpp)
        cd llama.cpp
        cmake -B build
        cmake --build build --config Release
        ```

**4. Combining GGUF files**

* Use the `llama-export-lora` tool to combine the base model and LORA adapter GGUF files into a single file:
    * Navigate to the `bin` directory within the build folder (e.g., `cd build/bin`).
    * Run the command with the following parameters:

        ```bash
        ./llama-export-lora \
          -m models/llama-3.2-3b-instruct-q8_0.gguf \
          -o models/combined.gguf \
          --lora models/llama-3.2-3B-instruct-q8-invoice-q8_0.gguf
        ```

**5. Creating Ollama Modelfile**

* Create a text file named `Modelfile` in the same directory as your combined GGUF file (`models/combined.gguf`).
* The content of the `Modelfile` should be a single line:

    ```
    From combined.gguf
    ```

**6. Loading the Model in Ollama**

* Use the `ollama` command to create and load the combined model:

    ```bash
    ollama create test_custom -f Modelfile
    ```

**7. Running the Model**

* To run the combined model in Ollama, use the following command:

    ```bash
    ollama run test_custom:latest
    ```

This process allows you to leverage the LORA adapter within the base model structure for invoice-specific tasks within Ollama.


