#!/usr/bin/env bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
PATHTOFILE="$(cat $SCRIPTPATH/controller.sh | grep 'WEBSERPIHOLE=' | awk -F'\"' '{ print $2 }' )"

printf "\n#########################"
printf "\n## Fetch adblock lists ##"
printf "\n######## Setup ##########"
printf "\n#########################\n\n"
while true; do
  read -p "Do you want to add the cronjob? [y/n]> " yn
  case $yn in
    [Yy]* )
      printf "\nWhat time to create the list?\n"
      read -p "Hour [0-23]> " hour
      read -p "Minute [0-59]> " minute
      sudo crontab -l > /tmp/crontab.tmp
      sed -i '/^*pihole -g*$/d' /tmp/crontab.tmp
      echo "$minute $hour * * * $SCRIPTPATH/controller.sh && pihole -g" >> /tmp/crontab.tmp
      crontab -u pi /tmp/crontab.tmp
      rm -f /tmp/crontab.tmp
      break;;
    [Nn]* )
      printf "\nNothing will be done here!"
      break;;
  esac
done
printf "\n\n"
while true; do
  read -p "Do you want to add your list to your adlists.list? [y/n]> " yn
  case $yn in
    [Yy]* )
      if [[ $(cat /etc/pihole/adlists.list | grep "http://localhost/$PATHOFFILE") == "" ]]; then
        printf "\nAdding your list to the adlist"
        cp /etc/pihole/adlists.list /tmp/
        echo "http://localhost/$PATHTOFILE" >> /tmp/adlists.list
        sudo cp /tmp/adlists.list /etc/pihole/adlists.list
        rm -f /tmp/adlists.list
      else
        printf "\nFile already in your adlists.list"
      fi
      break;;
    [Nn]* )
      printf "\nNothing will be done here!"
      break;;
  esac
done
printf "\n\nBye!\n"
