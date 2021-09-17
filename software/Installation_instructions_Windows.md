# Installation instructions Windows

Since this course makes use of the bash command line interface, here is how to get one on your windows opperating system.
If you have already a WSL installed on your system, please check that it uses **Ubuntu 20.04** or later.

## Installing Windows Subsystem Linux

Follow the manual installation steps on the [Microsoft documentation page](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

## Installing the required software within WSL

Now that WSL is installed, create a working directory on the subsystem.
In your WSL home directory, execute the following command:

`mkdir workdir && cd workdir`

Next, clone the Fortran-MOOC git repository inside this working directory:

`git clone https://github.com/gjbex/Fortran-MOOC/`

Navigate to Fortran-MOOC/software/containers:

`cd Fortran-MOOC/software/containers && ls` 

Here you can find a README file, a makefile and the bashscript development_node_install.sh.
This bash script will install the software required for this course. 

To execute the script do:
`bash development_node_install.sh`

Once this script completes, all necessary software should be installed correctly within your WSL. 
