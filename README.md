Installation
============

#### 1. [Download](https://cmder.net) the full cmder with Git for Windows. 

 Running it first time make sure it is starting up a bash shell.
 
 Settings -> Startup -> Specified named task -> select "{bash::bash}" option from the dropdown.
 
 Save settings.
 
 Restart cmder.
 
#### 2. from the new cmder run:
            git clone --recursive https://github.com/nagyg/workgroup.git ~/workgroup
            
The command above will download files from GitHub and might take some time.

#### 3. then run:
            ~/workgroup/bash/cleanrc.cmd - The command will backup and configure your .bash_profile .bash_userfile .bashrc

The command above will initialize your shell startup.

#### 4. exit / restart cmder
#### 5. from new cmder run:
            update.all
            
This will download some more meat.

#### 6. then run: 
            code $WGPATH/.wgsource
            
The line above will open vscode and edit the ~/workgroup/.wgsource file. 
Set up the environment variables here if it's needed. For example solidangle_LICENSE=5060@<COMPUTERNAME_PROVIDING_LICENSE> 

            
#### 7. restart cmder

You should be ready, good luck! 

### NOTE: you can check out / place your workgroup repo anywhere it was just an example.

The important members: 

Cmder running is bash mode -> you have a ~ / ${HOME} folder where your .bash_profile resides AND run on bash every startup.

At every startup .bash_profile runs a source command: source /pathto/.wgsource.  This is the point where you can relocate your workgroup! Move it anywhere and edit your .bash_profile accordingly. Example: move it to Q:\gfx\workgroup then your .bash_profile should contain the line "source /q/gfx/workgroup/.wgsource". 

Your workgroup folder contains a .wgsource file which is the last member. This file contains the components / variables will be set on starting up your cmder / conemu shell.
 




Update
======
close all applications
### git submodules and all url repo
            builtin cd ~/workgroup && git pull --recurse-submodules
            reload
            update.all
