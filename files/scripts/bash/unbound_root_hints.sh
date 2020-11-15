#!/bin/bash
wget -O root.hints https://www.internic.net/domain/named.root
sudo mv root.hints /var/lib/unbound/
