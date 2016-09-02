#
# Copyright (c) 2016 Malcolm Ramsay malramsay64@gmail.com
#
# Dockerfile to run lammps on a CentOS base install

FROM nvidia/cuda:7.5-centos7

RUN yum -y update &&\
    yum -y install \
    git \
    make \
    gcc-c++ \
    wget \
    python-devel \
    fftw3-devel \
    mpich-devel && \
    yum clean all 

RUN git clone git://git.lammps.org/lammps-ro.git /srv/lammps &&\ 
    cd /srv/lammps && \
    git checkout r15407 && \
    cd src && \
    mkdir -p MAKE/MINE

RUN cd /srv/lammps/lib/gpu && \
    export PATH=$PATH:/usr/lib64/mpich/bin && \
    make -f Makefile.linux.mixed CUDA_HOME=/usr/local/cuda-7.5 CUDA_ARCH=-arch=sm_50 && \
    cd ../../src &&\
    python Make.py -m none -cc g++ -mpi mpich -fft fftw3 -a file && \
    python Make.py -m auto -p molecule rigid gpu

RUN cd /srv/lammps/src && \
    make -j 4 auto MPI_INC="-DMPICH_SKIP_MPICXX -I/usr/include/mpich-x86_64" MPI_LIB="-Wl,-rpath,/usr/lib64/mpich/lib -L/usr/lib64/mpich/lib -lmpl -lmpich" FFT_LIB="-lfftw3" && \
    cp lmp_auto /bin/lmp_gpu

RUN mkdir /srv/input && mkdir /srv/scratch

ENV PATH /usr/lib64/mpich/bin:${PATH}







