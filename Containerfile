ARG UBU_VERSION
FROM ubuntu:${UBU_VERSION}

ENV LC_ALL=C

RUN apt-get update
RUN apt-get install -y \
    bash \
    git \
    wget \
    flex \
    bison \
    gperf \
    python3 \
    python3-pip \
    python3-venv \
    cmake \
    ninja-build \
    ccache \
    libffi-dev \
    libssl-dev \
    dfu-util \
    libusb-1.0-0

ENV IDF_TOOLS_PATH=/opt
ENV IDF_PATH=$IDF_TOOLS_PATH/idf
WORKDIR $IDF_PATH
ARG IDF_VERSION
RUN git clone -c advice.detachedHead=false --recursive --branch ${IDF_VERSION} --depth 1 https://github.com/espressif/esp-idf.git .
RUN ./install.sh esp32c3

ENV MPY_PATH=/opt/mpy
WORKDIR $MPY_PATH
ARG MPY_VERSION
RUN git clone -c advice.detachedHead=false --recursive --branch ${MPY_VERSION} --depth 1 https://github.com/micropython/micropython.git .

RUN rm -rf $(find /opt -name ".git")

CMD ["bash"]

LABEL org.opencontainers.image.source https://github.com/burgrp/mpy-builder-esp32c3
LABEL org.opencontainers.image.description MicroPython builder for ESP32C3

