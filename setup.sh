#!/usr/bin/env bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
PATHTOFILE="$(cat $SCRIPTPATH/controller.sh | grep 'WEBSERPIHOLE=')"

printf "\n#########################"
printf "\n## Fetch adblock lists ##"
printf "\n######## Setup ##########"
printf "\n#########################\n\n"
read -p "Do you want to add the cronjob? [y/n]> " yn
case $yn in
  [Yy]* )
    printf "\nWhat time to create the list?\n"
    read -p "Hour [0-23]> " hour
    read -p "Minute [0-59]> " minute
    sudo crontab -l > /tmp/crontab.tmp
    sed -i /^*pihole -g*$/d /tmp/crontab.tmp
    echo "$minute $hour * * * $SCRIPTPATH/controller.sh && pihole -g" >> /tmp/crontab.tmp
    crontab -u pi /tmp/crontab.tmp
    rm /tmp/crontab.tmp
    break;;
  [Nn]* )
    printf "\nNothing will be done here!"
esac
printf "\n\n"
read -p "Do you want to add your list to your adlists.list? [y/n]> " yn
case $yn in
  [Yy]* )
    printf "\nAdding your list to the adlist"
    sudo echo "http://localhost/$PATHTOFILE" >> /etc/pihole/adlists.list
    break;;
  [Nn]* )
    printf "\nNothing will be done here!"
esac
printf "\n\nBye!\n"
