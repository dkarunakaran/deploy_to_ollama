FROM python:3.12.5-bookworm

RUN pip install --upgrade pip

##### Core scientific packages
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
RUN pip install pillow>=6.2.0
RUN pip install pytesseract>=0.2.6
RUN pip install werkzeug>=2.0
RUN pip install tensorboard
RUN pip install bitsandbytes==0.43.2
RUN pip install peft==0.8.2
RUN pip install transformers==4.46.2

WORKDIR /app

CMD ["/bin/bash"]