'''Recipe to create either a docker container or Singularity image
for a compute node on which users can log in using password authentication.
The SQS queue system is available as well as a number of editors, git,
make, CMake, GCC and Open-MPI

Usage:
    # hpccm.py --recipe compute_node.py --format docker
    # hpccm.py --recipe compute_node.py --format singularity
'''

# Choose a base image, use most recent Ubuntu
Stage0.baseimage('ubuntu:20.04')
 
# Install build tools.
Stage0 += apt_get(ospackages=['build-essential'])
# Stage0 += apt_get(ospackages=['make'])
Stage0 += cmake(eula=True)

# Install GNU compilers (upstream).
compilers = gnu()
Stage0 += compilers

# Install Open-MPI (this can be done better, but we don't need an optimized version).
Stage0 += apt_get(ospackages=['libopenmpi-dev', 'openmpi-common', 'openmpi-bin'])

# Install debugging tools.
Stage0 += apt_get(ospackages=['gdb', 'valgrind', 'strace'])

# Installing documentation generation
Stage0 += apt_get(ospackages=['doxygen'])

# Installing scientific libraries
Stage0 += apt_get(ospackages=['libgsl-dev', 'libopenblas-dev', 'liblapack-dev',
                              'libhdf5-dev', ])

# Installing Python & numpy
Stage0 += apt_get(ospackages=['python3', 'python3-numpy', 'jupyter-notebook'])

# Install some edtiors
Stage0 += apt_get(ospackages=['nano', 'vim', 'emacs', 'less'])

# Install version control.
Stage0 += apt_get(ospackages=['git'])

# Install archive and compression software and utitlies.
Stage0 += apt_get(ospackages=['tar', 'gzip', 'bzip2'])

# Install visualization software
Stage0 += apt_get(ospackages=['gnuplot'])
