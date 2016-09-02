lammps_gpu
==========

This is a docker container build on CentOS 7 that runs lammps with gpu acceleration. To use the gpu acceleration this container needs to be run with the `nvidia-docker` command (see install section for details).

Running lammps
--------------

To run the docker container run the command

    nvidia-docker -ti run -v $(pwd):/srv/input -v $HOME/scratch:/srv/scratch malramsay/lammps_gpu

which will bring up a command prompt. Running lammps is relatively simple

    lmp_gpu -in /srv/lammps/bench/in.lj

and it is possible to run as an mpi process

    mpirun -np 4 lmp_gpu -in /srv/lammps/bench/in.lj

and/or with gpu acceleration

    lmp_gpu -in /srv/lammps/bench/in.lj -sf gpu

Installing Docker
-----------------

A quick rundown of installing docker on Ubuntu 16.04, more detailed instructions and instructions for other distributions can be found in the docker [documentation](docs.docker.com/engine/installation/linux).

    sudo apt-get update
    sudo apt-get install apt-transport-https ca-certificates linux-image-extra-$(uname -r) linux-image-extra-virtual
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt-get update
    sudo apt-get install docker-engine
    sudo systemctl enable docker
    sudo docker run hello-world
    sudo usermod -aG docker $USER
    sudo shutdown -r now

Installing nvidia-docker
------------------------

This is a relatively simple process documented in the [repository](https://github.com/NVIDIA/nvidia-docker#ubuntu-distributions)

    wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.0-rc.3/nvidia-docker_1.0.0.rc.3-1_amd64.deb
    sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb
    nvidia-docker run --rm nvidia/cuda nvidia-smi

