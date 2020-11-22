#!/bin/bash
# This script will download the oisd.nl block list and create a unbound compatible block list.
# The black- & white-list from the Aha.Dns.Domains is also used (source: https://github.com/AhaDNS/Aha.Dns.Domains)
# Author: NoExitTV (Fredrik Pettersson)
# For: AhaDNS.com
#================================================================================
TICK="[\e[32m ✔ \e[0m]"

if [ "$(id -u)" != "0" ] ; then
        echo "This script requires root permissions. Please run this as root!"
        exit 2
fi

echo "Triggered update of unbound blocklist"
curl -sS https://dbl.oisd.nl/ | sudo tee -a blocklist.txt >/dev/null
echo -e " ${TICK} \e[32m Downloaded blocklist from dbl.oisd.nl... \e[0m"
sleep 0.1
curl -sS https://raw.githubusercontent.com/AhaDNS/Aha.Dns.Domains/master/Domains/blacklist.txt | sudo tee -a blocklist.txt >/dev/null
echo -e " ${TICK} \e[32m Downloaded AhaDNS blacklist from the Aha.Dns.Domains repository... \e[0m"
sleep 0.1
echo -e " ${TICK} \e[32m Removing duplicates... \e[0m"
mv blocklist.txt blocklist.txt.old && cat blocklist.txt.old | sort | uniq >> blocklist.txt
sleep 0.1
echo -e " ${TICK} \e[32m Converting to unbound format... \e[0m"
cat blocklist.txt | grep '^[A-Za-z0-9åäöÅÄÖ]' | awk '{print "local-zone: \""$1"\" always_refuse"}' > unbound_blocklist.conf
sleep 0.1
echo -e " ${TICK} \e[32m Moving blocklist to unbound directory... \e[0m"
sudo cp unbound_blocklist.conf /etc/unbound/unbound_blocklist.conf
sleep 0.1
echo -e " ${TICK} \e[32m Cleanup old resources... \e[0m"
rm unbound_blocklist.conf
rm blocklist.txt
rm blocklist.txt.old
echo "Blocklist updated"

echo "Triggered update of unbound whitelists"
curl -sS https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt | sudo tee -a whitelist.txt >/dev/null
echo -e " ${TICK} \e[32m Adding anudeepND's domains to whitelist... \e[0m"
sleep 0.1
curl -sS https://raw.githubusercontent.com/AhaDNS/Aha.Dns.Domains/master/Domains/whitelist.txt | sudo tee -a whitelist.txt >/dev/null
echo -e " ${TICK} \e[32m Adding AhaDNS whitelist from Aha.Dns.Domains... \e[0m"
sleep 0.1
echo -e " ${TICK} \e[32m Removing duplicates... \e[0m"
mv whitelist.txt whitelist.txt.old && cat whitelist.txt.old | sort | uniq >> whitelist.txt
sleep 0.1
echo -e " ${TICK} \e[32m Converting to unbound format... \e[0m"
cat whitelist.txt | grep '^[A-Za-z0-9åäöÅÄÖ]' | awk '{print "local-zone: \""$1"\" transparent"}' > unbound_whitelist.conf
sleep 0.1
echo -e " ${TICK} \e[32m Moving whitelist to unbound directory... \e[0m"
sudo cp unbound_whitelist.conf /etc/unbound/unbound_whitelist.conf
sleep 0.1
echo -e " ${TICK} \e[32m Cleanup old resources... \e[0m"
rm whitelist.txt
rm whitelist.txt.old
rm unbound_whitelist.conf
echo "Whitelist updated"

echo "Trigger unbound reload"
echo -e " ${TICK} \e[32m Triggering unbound to reload config... \e[0m"
sudo unbound-control -c /etc/unbound/unbound.conf reload
echo "Execution completed!"
