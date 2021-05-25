# Containers

Container definitions that contain the software required for the MOOC 'Fortran for scientific programming'.


## What is it?

1. [`development_node.py`](development_node.py): hpccm defintion file that can be used to
   generate a Singularity recipe, a Docker file, or a bash install script based on Ubuntu 21.04..
1. [`development_node_20_04.py`](development_node.py): hpccm defintion file that can be used to
   generate a bash installer script based on Ubuntu 20.04.
1. [`Makefile`](Makefile): make file to create the container recipes.
1. [`development_node.def`](development_node.def): Singularity recipe for building the image.
1. [`Dockerfile`](Dockerfile): Docker file describing the container.
1. [`development_node_install.sh`](development_node_install.sh): Bash install script (using apt).

The docker image is available on [Docker Hub](https://hub.docker.com/) and can be pulled
using:
```bash
$ docker pull gjbex/fortran-mooc:latest
```

The Singularity image is available on [Sylabs.io](https://cloud.sylabs.io/home) and
can be pulled using:
```bash
$ singularity pull --arch amd64 library://gjbex/default/fortran-mooc:1.0
```
