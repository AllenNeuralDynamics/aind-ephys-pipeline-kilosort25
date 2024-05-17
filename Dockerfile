FROM continuumio/miniconda3:23.9.0-0

ARG DEBIAN_FRONTEND=noninteractive


RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        fonts-freefont-ttf=20120503-10 \
    && rm -rf /var/lib/apt/lists/*

# correct mapping to make libvips work
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libffi.so.7

# install libvips
RUN apt-get update \
    && apt-get install -y libvips libvips-dev libvips-tools libtiff5-dev

# install default fonts
RUN apt-get install -y fonts-freefont-ttf


RUN pip install -U --no-cache-dir \
    aind-data-schema==0.22.1 \
    pyvips==2.2.1 \
    spikeinterface[full,widgets]==0.100.6 \
    zarr==2.17.2 \
    torch==2.2.0 \
    wavpack-numcodecs==0.1.5