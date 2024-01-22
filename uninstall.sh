#!/bin/bash
# shellcheck disable=SC2162

set -e

echo This shell script will install e5renewx on your linxu system.
read -s -n1 -p "press any key to continue ... "
echo Starting job...

rm -rf "$HOME"/dotnet
rm -rf "$HOME"/renewx
rm -rf /usr/local/bin/starte5renewx

echo Uninstallation Complete!
