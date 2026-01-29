FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ACT_HOME=/usr/local/cad

RUN apt-get update && apt-get install -y \
    ca-certificates \
    git \
    build-essential \
    cmake \
    libedit-dev \
    zlib1g-dev \
    m4 \
    libfmt-dev \
    libboost-all-dev \
    libopenmpi-dev \
    llvm \
    flex \
    bison \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN git clone https://github.com/asyncvlsi/actflow.git && \
    cd actflow && \
    git submodule update --init --recursive

# Build ACTFlow tools into the image so new containers have actsim/act/etc.
WORKDIR /opt/actflow
RUN mkdir -p ${ACT_HOME} && \
    ./build

# Make ACT tools available automatically for interactive shells
RUN echo 'source /opt/actflow/run.sh' >> /root/.bashrc

CMD ["/bin/bash"]
