#!/bin/bash

# ask user a question: "Do you want to update apt, this may cause a reboot?"
# if yes, then run `sudo apt-get update` and `sudo apt-get upgrade`
# if no, then skip
echo "
Do you want to update apt, this may cause a reboot?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) sh ./setup-apt.sh; break;;
        No ) exit;;
        * ) exit;;
    esac
done

# setup for non-root user
sh ./create-user.sh
cp ./ssh-init.sh /home/pootow/ssh-init.sh
chown pootow:pootow /home/pootow/ssh-init.sh
su pootow -c "cd ~ && sh ./ssh-init.sh"

# sh ./setup-os-opt.sh
# mordern linux kernel has already enabled bbr congestion control algorithm

sh ./setup-sshd.sh

sh ./setup-docker.sh

# run v2fly setup script as pootow
cd v2fly
su pootow -c "sh ./setup-v2fly.sh"
