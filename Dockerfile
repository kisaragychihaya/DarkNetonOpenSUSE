FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04
RUN apt update && apt upgrade -y && apt install -y libstb-dev  git build-essential
RUN git clone https://github.com/AlexeyAB/darknet && cd darknet && \
    sed -i 's/GPU=0/GPU=1/g' Makefile  &&  sed -i 's/CUDNN=0/CUDNN=1/g'  Makefile  && \
    sed -i '8,12d' Makefile && sed -i 's/-gencode arch=compute_61,code=[sm_61,compute_61] /ARCH= -gencode arch=compute_61,code=[sm_61,compute_61] /g'  Makefile  &&  make -j4 && \
    cp darknet /usr/local/bin/darknet