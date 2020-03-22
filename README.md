Installation
============

#### 1. [Download](https://cmder.net) the full cmder with Git for Windows. 

 By running cmder.exe the first time make sure it is starting up a bash shell.
 
 - Settings -> Startup -> Specified named task -> select "{bash::bash}" option from the dropdown.
 
 - Save settings.
 
 - Exit / Restart cmder.
 
#### 2. From the new cmder run:
            git clone --recursive https://github.com/nagyg/workgroup.git ~/workgroup
            
The command above will download files from GitHub and might take some time.

#### 3. Then run:
            ~/workgroup/bash/cleanrc.cmd

The command above will initialize your shell startup. Backs up and configures your .bash_profile .bash_userfile .bashrc

#### 4. Exit / Restart cmder
#### 5. From the new cmder run:
            update.all
            
This will download some more meat.

#### 6. Then run: 
            code $WGPATH/.wgsource
            
The line above will open vscode and edit the ~/workgroup/.wgsource file. 
Set up the environment variables here if it's needed.

##### Example:
            export solidangle_LICENSE=5060@(COMPUTERNAME_PROVIDING_LICENSE)
            export genarts_LICENSE="$(cygpath -w "${WGPATH}/plugins/borisfx/mocha/mochapro.lic")"

#### 7. Last exit / Restart cmder

You should be ready, good luck!

Update
======
Close all applications then run the following commands.
### This will update all git submodules and all url / binary repos
            builtin cd ~/workgroup && git pull --recurse-submodules
            reload
            update.all
            
#### NOTE: you can check out / place your workgroup repo anywhere. The instructions above were just an example.

The important members: 

Cmder running is bash mode -> you have a ~ / ${HOME} folder where your .bash_profile resides AND runs on bash every startup.

At every startup .bash_profile runs a source command: source /pathto/.wgsource.
This is the point where you can relocate your workgroup! Move it anywhere and edit your .bash_profile accordingly.

##### Example: move it to "Q:\path to\workgroup" then your .bash_profile should contain the line:
            source /q/path\ to/workgroup/.wgsource

Your workgroup folder contains a .wgsource file which is the last member. 
This file contains the components / variables will be set on starting up your cmder / conemu shell.