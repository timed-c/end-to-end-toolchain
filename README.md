# Installing Docker
### Windows
For windows 10 enterprise follow instructions to install docker desktop at
https://docs.docker.com/docker-for-windows/install/
For other windows version follow instructions to install docker toolbox at
https://docs.docker.com/toolbox/toolbox_install_windows/

### Ubuntu
For Ubuntu follow instruction at
https://docs.docker.com/install/linux/docker-ce/ubuntu/

### Mac OS
For Mac OS follow instruction at
https://docs.docker.com/docker-for-mac/install/

### Installing e2e using Docker
    git clone https://github.com/saranya-natarajan/end-to-end-toolchain.git
    cd e2e
    docker build --tag=e2e .
