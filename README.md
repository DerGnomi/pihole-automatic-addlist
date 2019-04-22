# pihole-automatic-addlist
Automaticly fetching new adlist every day.

## Setup

To setup the Cronjob and update the adlists.list start the "setup.sh"

If you want to use another webserver base dir, change it in controller.sh, it will be fetched there.

## manually setup

add a cronjob like

```bash
0 1 * * * /home/pi/pihole-automatic-addlist/controller.sh && pihole -g
```

and add the following line to the /etc/pihole/adlists.list
```bash
http://localhost/hosts/main.txt
```

## Settings

### GENERAL

In the controller.sh script you can chose whether you want to take the ticked or non crossed or all lists

### COINMINERLIST

If you dont want to cancel out the coinblocker list, then set the var "SPECIALLIST" to false

## How does it work

The controller.sh script fetches all lists from the firebog page, safes them into linklist.txt.

Then every list gets downloaded with curl.

After that the strings "127.0.0.1", "0.0.0.0", "0 " and some escape sequenzes get filtered out, so the pihole script can do pull the gravity list faster.

Finally the list get sorted and duplicated fqdn get deleted, the list will be copied to the webserver dir.

### Questions and Help 

to dominic@lazarus-network.org
