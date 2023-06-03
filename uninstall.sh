#!/bin/bash

set -eux

echo This shell script will install e5renewx on your linxu system.
read -s -n1 -p "press anykey to continue ... "
echo Starting job...

sudo rm -rf $HOME/dotnet
sudo rm -rf $HOME/renewx
sudo rm -rf /usr/local/bin/starte5renewx

echo Uninstallation Complete!
