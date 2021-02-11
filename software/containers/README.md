# Containers

Container definitions that contain the software required for the MOOC 'Fortran for scientific programming'.


## What is it?

1. [`development_node.py`](development_node.py): hpccm defintion file that can be used to generate a Singularity recipe or a
   Docker file.
1. [`development_node.def`](development_node.def): Singularity recipe for building the image.
1. [`Dockerfile`](Dockerfile): Docker file describing the container.
1. [`development_node_install.sh`](development_node_install.sh): Bash install script (using apt).
