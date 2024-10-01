#!/bin/bash


grep "sudo" /etc/group

while true;
do
  read -p "Unauthorized User: " user
  sudo gpasswd -d $user sudo
done
