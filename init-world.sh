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

sh ./setup-os-opt.sh

sh ./setup-sshd.sh


# setup for non-root user
sh ./create-user.sh
su pootow
sh ./ssh-init.sh

sh ./setup-docker.sh
