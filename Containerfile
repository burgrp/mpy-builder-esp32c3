FROM mcr.microsoft.com/devcontainers/base:debian

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

ENV IDF_PATH=/esp/idf

WORKDIR $IDF_PATH

ARG IDF_VERSION
RUN git clone -c advice.detachedHead=false --recursive --branch ${IDF_VERSION} --depth 1 https://github.com/espressif/esp-idf.git .

ENV IDF_TOOLS_PATH=/esp
RUN ./install.sh esp32c3
RUN ln -s /esp/idf/tools/idf.py /esp/idf/tools/idf
RUN rm -rf $(find /esp -name ".git")

ARG IMAGE_NAME
COPY init /esp/init
COPY init-project /usr/bin/

ENV LC_ALL=C

CMD ["bash"]

LABEL org.opencontainers.image.source https://github.com/burgrp/esp-idf.git
LABEL org.opencontainers.image.description ESP32 IDF $IDF_VERSION tooling

