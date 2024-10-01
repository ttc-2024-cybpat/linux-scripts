#!/bin/bash

#should this be '/g' global?
sudo passwd --mindays 10 --maxdays 60

#no login as root
sudo passwd -l root

#check for nopasswd
# remove lines with these
# is this safe though?
sed 's/.*(nopasswd|!authenticate).*//' /etc/sudoers


