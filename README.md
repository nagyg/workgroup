Installation
============

#### 1. [Download](https://cmder.net) full cmder with Git for Windows. 

 Running it first time make sure it is starting up a bash shell.
 
 Settings -> Startup -> Specified named task -> select "{bash::bash}" option from the dropdown.
 
 Save settings.
 
 Restart cmder.
 
### 2. run bash:
            git clone --recursive https://github.com/nagyg/workgroup.git ~/workgroup
#### 3. start ~/workgroup/bash/cleanrc.cmd - backup and config your .bash_profile .bash_userfile .bashrc
#### 4. restart cmder
#### 5. run bash: - download meat from url
            update.all
#### 6. run bash: - open and edit ~/workgroup/.wgsource file
            code $WGPATH/.wgsource
#### 7. restart cmder

Update
======
close all applications
### git submodules and all url repo
            builtin cd ~/workgroup && git pull --recurse-submodules
            reload
            update.all
