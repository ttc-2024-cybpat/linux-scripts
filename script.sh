#!/bin/bash

#should this be '/g' global?
sudo passwd --mindays 10 --maxdays 60

#no login as root
sudo passwd -l root

#check for nopasswd
# remove lines with these
# is this safe though?
sudo sed -i 's/.*(nopasswd|!authenticate).*//' /etc/sudoers

#set pam remember to 14
#try to replace the current value
old=$(< /etc/pam.d/common-password) 
sudo sed -i 's/pam_history[  ]\+remember[ ]*=[ ]*[0-9]*/pam_history.so remember=14' /etc/pam.d/common-password
new=$(< /etc/pam.d/common-password) 
if [ "$new" == "$old" ];
then
  sudo echo "pam_history.so remember=14" >> /etc/pam.d/common-password
fi

#remove uneccesary pkgs
sudo apt purge telnetd rsh-server
sudo apt autoremove

#ssh
#assumes spaces only (not tabs)
sudo sed -i 's/PermitRootLogin *yes/PermitRootLogin *no/' /etc/ssh/ssh_config

