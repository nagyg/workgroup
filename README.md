Installation
============

#### 1. [Download](https://cmder.net) the full cmder with Git for Windows. 

 Running it first time make sure it is starting up a bash shell.
 
 Settings -> Startup -> Specified named task -> select "{bash::bash}" option from the dropdown.
 
 Save settings.
 
 Restart cmder.
 
#### 2. from cmder run:
            git clone --recursive https://github.com/nagyg/workgroup.git ~/workgroup
            
The command above will download files from GitHub and might take some time.

#### 3. from cmder run:
            ~/workgroup/bash/cleanrc.cmd - The command will backup and configure your .bash_profile .bash_userfile .bashrc

The command above will initialize your shell startup.

#### 4. restart cmder
#### 5. from cmder run:
            update.all
            
This will download some more meat.

#### 6. from cmder run: 
            code $WGPATH/.wgsource
            
The line above will open vscode and edit the ~/workgroup/.wgsource file. 
Set up the environment variables here if it's needed. For example solidangle_LICENSE=5060@<COMPUTERNAME_PROVIDING_LICENSE> 

            
#### 7. restart cmder




Update
======
close all applications
### git submodules and all url repo
            builtin cd ~/workgroup && git pull --recurse-submodules
            reload
            update.all
