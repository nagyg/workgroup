Installation
============

#### 1. [Download](https://cmder.net) the full cmder with Git for Windows. 

 By running cmder.exe the first time make sure it is starting up a bash shell.
 
 - Cmder.exe run as administrator 

 - Settings -> Startup -> Specified named task -> select "{bash::bash}" option from the dropdown.
 
 - Save settings.
 
 - Exit / Restart cmder.
 
Check the images below in case you are wondering where are those settings we are talking about:
![alt text](https://github.com/nagyg/workgroup/blob/master/setup/docs/cmder_settings.png?raw=true)

#### 2. From the new cmder run:
            git clone https://github.com/nagyg/workgroup.git ~/workgroup
            
The command above will download files from GitHub and might take some time.

#### 3. Then run:
            ~/workgroup/setup/cleanrc.cmd

The command above will initialize your shell startup. Backs up and configures your .bash_profile .bash_userfile .bashrc

#### 4. Exit / Restart cmder
#### 5. From the new cmder run:
            echo 'rsync password' > $WGPATH/setup/cwrsync/etc/rsyncd.passwd
            
Create passwd file for rsync
            update.all
            
This will download some more meat.

#### 6. Then run: 
            code ~/.bash_profile $WGPATH/.licenses
            
The line above will open vscode and edit the ~/.bash_profile and $WGPATH/.licenses files. 
Set up the environment variables here if it's needed.

##### Example:
            export solidangle_LICENSE=5060@<COMPUTERNAME_PROVIDING_LICENSE>
            export genarts_LICENSE="$(cygpath -w "$WGPATH/plugins/borisfx/mochapro.lic");5061@<COMPUTERNAME_PROVIDING_LICENSE>"

#### 7. Last exit / Restart cmder

You should be ready, good luck!

Update
======
Close all applications then run the following commands.
### This will update git and all rsync / binary repos
            builtin cd ~/workgroup && git pull
            # Now restart conemu and enter the following command:
            update.all
            
#### NOTE: you can check out / place your workgroup repo anywhere. The instructions above were just an example.

The important members: 

Cmder running is bash mode -> you have a ~ / ${HOME} folder where your .bash_profile resides AND runs on bash every startup.

At every startup .bash_profile runs a source command: source /pathto/.wgsource.
This is the point where you can relocate your workgroup! Move it anywhere and edit your .bash_profile accordingly.

##### Example: move it to "Q:\path to\workgroup" then your .bash_profile should contain the line:
            source /q/path\ to/workgroup/.wgsource

Your workgroup folder contains a .wgsource file which is the last member. 
This file contains the components / variables will be set on starting up your cmder / conemu shell. Don't touch this file! Your .bash_profile drives it. So, tweak that if something must be tweaked.

#### Example: Isolated environment
By default the configuration expect a .bash_profile file to be found on "c:\Users\Sandor" or "/home/sandor".
If you don't want to mess with the existing stuff there then you can create an isolated environment.

A quick description follows: Create a dir anywhere. This will be the root dir later in the example. 
 Extract cmder.zip into root. Clone this repo into root. Hack yourself a HOME env.variable into <root>/config/user_profile.sh which can be
done by adding a line like this: export HOME='/a/wg'; The path is the path to the root directory. The install steps will do the rest. Keep your eye on cleanrc.cmd! The .bash_profile it creates is in your OS user's home.  ( "c:\Users\Sandor" or "/home/sandor" ) Move the new .bash_profile to root. Restore your old .bash_profile from the backup if needed. 
 
Rather dirty but also very quick-safe-clean.
