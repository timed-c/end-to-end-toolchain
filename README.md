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

### Installing e2e Using Docker

    git clone https://github.com/saranya-natarajan/end-to-end-toolchain.git
    cd end-to-end-toolchain
    git submodule init
    git submodule update
    docker build --tag=e2e .

## Testing the Installation
    docker run -it e2e
    cd profile-test
    ./run-end.sh test1.c

Output:
...
input_scaled.csv:SCHEDULABLE
Completed


### Updating e2e Docker
Note : do this only after your intial installation is done successfully.
Otherwise, follow steps listed above in installing e2e using docker.

    git pull
    docker build --tag=e2e .


### Running your program on e2e Docker
    docker run -it e2e
    cd profile-test
    cp test1.c <filename>
    <keep the headers write your program and save>
    ./run-end.sh filename.c

