FROM nvidia/cuda:12.1.1-devel-ubuntu22.04
ENV HOST 0.0.0.0
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y git ffmpeg build-essential portaudio19-dev \
    python3 python3-pip gcc wget git \
    ocl-icd-opencl-dev opencl-headers clinfo \
    libclblast-dev libopenblas-dev libaio-dev \
    && mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd \
    && ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /app
ENV CUDA_DOCKER_ARCH=all
RUN git clone https://github.com/JonahMMay/alltalk_tts && cd ./alltalk_tts && git checkout alltalkbeta
WORKDIR /app/alltalk_tts
COPY ./system/requirements/requirements_docker.txt ./system/requirements/requirements_docker.txt
COPY ./launch.sh ./launch.sh
COPY ./modeldownload.json ./modeldownload.json
COPY ./modeldownload.py ./modeldownload.py
RUN pip install --no-cache-dir --no-deps -r ./system/requirements/requirements_docker.txt && \
    pip install --no-cache-dir deepspeed

EXPOSE 7851 7852
RUN chmod +x launch.sh
ENTRYPOINT ["sh", "-c", "/app/alltalk_tts/launch.sh"]
