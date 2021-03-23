# Installation instructions Windows

Since this course makes use of the bash command line interface, here is how to get one on your windows opperating system.
If you have already a WSL installed on your system, please check that it uses Ubuntu 20.04 or later.

## Installing Windows Subsystem Linux

**1.** 
Open PowerShell as Administrator. This can be done through the start menu. 
Scroll down and expand the Windows PowerShell folder. 
Right-click Windows PowerShell and choose: Run as Administrator 

**2.** 
In the PowerShell prompt, execute the command:
 
`Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux`

**3.**
Once the download is complete, PowerShell will will ask you if you want to reboot your computer to enable the Linux subsystem.
###Before doing this, make sure your work is saved and close any open applications!
Then type "Y" to reboot.

**4.**
After the reboot, open a new command prompt and execute:
`bash`

You will receive the message that no distribution is installed yet. 
Open the windows store and *download* Ubuntu 20.04 LTS
When the installation is complete, click *Launch*.
Since this is the first time you launched WSL, you are asked to create a new user account:

`Enter new UNIX username:`

`Enter new UNIX password:`

`Retype new UNIX password:`

### Tip:
Accessing local files stored on your windows file system from WSL can be somewhat troublesome at first.
You can navigate to a folder on the windows file system with 
`cd /mnt/C/Users/...`
or alternatively, you can instantiate the bash terminal from inside the folder you want to access.

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
