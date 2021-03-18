# Installing the software requirements in Linux

Clone the Fortran-MOOC repository into your desired location.

`git clone https://github.com/gjbex/Fortran-MOOC/`

Navigate to Fortran-MOOC/software/containers:

`cd Fortran-MOOC/software/containers && ls`

Here you can find a README file, a makefile and the bashscript development_node_install.sh. This bash script will install the software required for this course. Changing the file permissions of the bash script to 777 will allow you to execute it:

`chmod 777 development_node_install.sh`

Use the following command to run the script:

`./development_node_install.sh`

Note that this script makes use of apt to install the software. 
If you use a different package manager you can use those to install the software manually (e.g. yum or pacman)
