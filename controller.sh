#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONTROLLER=`basename "$0"`
SCRIPTPATHCONTROLLER="$SCRIPTPATH/$ME"
LINKLIST="$SCRIPTPATH/linklist.txt"
LISTDIR="$SCRIPTPATH/lists"
ALLLIST="$LISTDIR/fulllist.txt"
SEDLIST="$LISTDIR/sedlist.txt"
SORTLIST="$LISTDIR/sortedlist.txt"

## Webserver root dir
WEBSERDIR="/var/www/html"
## Files stored
WEBSERPIHOLE="hosts/main.txt"
## FULL PATH
WEBSERPATH="$WEBSERDIR/$WEBSERPIHOLE"

## List from https://firebog.net/
## View all catch list in linklist.txt

##########
## LIST ##
##########

## Options: TICK, NOCROSS, ALL

LIST="TICK"

if [[ $LIST == "TICK" ]]; then
  curl "https://v.firebog.net/hosts/lists.php?type=tick" -o $LINKLIST
elif [[ $LIST == "NOCROSS" ]]; then 
  curl "https://v.firebog.net/hosts/lists.php?type=nocross" -o $LINKLIST
else
  curl "https://v.firebog.net/hosts/lists.php?type=all" -o $LINKLIS
fi

###################################
## download and manipulate lists ##
###################################

## Create dir if it does not exists
if [[ ! -d $LISTDIR ]]; then
  mkdir $LISTDIR
fi

## delete previous created lists
if [[ -f $ALLLIST ]]; then 
  rm $ALLLIST
fi
if [[ -f $SEDLIST ]]; then
  rm $SEDLIST
fi
if [[ -f $SORTLIST ]]; then
  rm $SORTLIST
fi

## fetch all lists in one big list
for i in $(cat $LINKLIST)
do
  curl $i >> $ALLLIST 
done

## format the list - rule out all "127.0.0.1", "0.0.0.0", "0 ", "#IBM Silverpop" 
## Strip of all escape sequenzes
sed -e '/^127.0.0.1/d' $ALLLIST | sed -e '/^0.0.0.0/d' | sed -e '/#IBM Silverpop/d' | sed -e '/^0 /d' | sed 's/\r$//' | grep -v ^$ | grep -v "^#" > $SEDLIST

## sort list from 0-9,a-z and delete multiple fqdns
sort -u -o $SORTLIST $SEDLIST

############################
## Copy list to webserver ##
############################

sudo cp $SORTLIST $WEBSERPATH
sudo chown pi:www-data $WEBSERPATH
