## Introduction to Docker
The Docker is a tool that allows developers to package their application in a sandbox, called container. The docker image of an application can run on all host OS that support docker. Note that the Docker image is an executable version of the application. A container is create when a docker image is run on the host OS.

### A Small List of Useful Docker Commands
(i) List of docker images on the system

    docker images
(ii) List of all running docker container

    docker ps
(iii)  Open an interactive tty in the container (This allows execution of multiple commands and gives access to the folder within the container)

     docker run -it <name_of_docker_image>

## Installing e2e toolchain
This document describe how to install the e2e toolchain as a docker container image. This e2e docker container image is known to work on ubuntu, linux, and windows machines.
Prerequisite : Docker Software

### Step 1: Installing Docker
If the docker sofware is installed on your machine you can go to step 2.
##### Windows
For windows follow instruction at
https://docs.docker.com/docker-for-windows/install/

##### Ubuntu
For Ubuntu follow instruction at
https://docs.docker.com/install/linux/docker-ce/ubuntu/

##### Installing Docker on Mac OS
For Mac OS follow instruction at
https://docs.docker.com/docker-for-mac/install/

### Step 2: Installing E2E Docker Container Image

    git clone https://github.com/saranya-natarajan/end-to-end-toolchain.git
    cd end-to-end-toolchain
    git submodule init
    git submodule update
    docker build --tag=e2e .

#### Step 3: Testing the Installation
    docker run -it e2e
    cd profile-test
    ./run-end.sh test1.c

Output:
...
Completed


#### Updating E2E Docker Container Image
Note : do this only after your intial installation is done successfully.

    git pull
    docker build --tag=e2e .

#### Running your program on E2E Docker Image
The following steps takes you into the e2e container folder. Hence, you do not have access to your host machine's file system. All files are created inside the container and lost when you exit the conatiner. You will have to install an editor of your choice.

    docker run -it e2e
    cd profile-test
    cp test1.c <filename>
    <keep the headers write your program and save>
    ./run-end.sh filename.c








