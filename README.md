Installation
============

#### 1. [Download](https://cmder.net) full cmder with Git for Windows
#### 2. run bash:
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
### workgroup
            builtin cd ~/workgroup && git pull --recurse-submodules
            reload
            update.all

### arnold

            update.solidangle