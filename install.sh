#!/bin/bash
set -eux
if [ -f /usr/bin/apt-get ]
then
    sudo apt update
    sudo apt install libc6 libgcc-s1 libgssapi-krb5-2 libssl* libstdc++6 zlib1g libgdiplus tar xz-utils zip unzip wget -y
else
    echo only support debian system! ; exit 1
fi

get_arch=`arch`
if [[ $get_arch =~ "x86_64" ]];then
    wget https://download.visualstudio.microsoft.com/download/pr/e89c4f00-5cbb-4810-897d-f5300165ee60/027ace0fdcfb834ae0a13469f0b1a4c8/dotnet-sdk-3.1.426-linux-x64.tar.gz
elif [[ $get_arch =~ "aarch64" ]];then
    wget https://download.visualstudio.microsoft.com/download/pr/79f1cf3e-ccc7-4de4-9f4c-1a6e061cb867/68cab78b3f9a5a8ce2f275b983204376/dotnet-sdk-3.1.426-linux-arm64.tar.gz
elif [[ $get_arch =~ "armhf" ]];then
    wget https://download.visualstudio.microsoft.com/download/pr/2043e641-977d-43ac-b42a-f47fd9ee79ba/5b10d12a0626adaed720358ab8ad0b7e/dotnet-sdk-3.1.426-linux-arm.tar.gz
else
    echo "unsupported architecture!!" ; exit 1
fi

mkdir -p $HOME/dotnet && tar zxf dotnet*.tar.gz -C $HOME/dotnet

wget https://download.saika2077.repl.co/d/Guest/Microsoft365_E5_Renew_X.zip
unzip Microsoft365_E5_Renew_X.zip -d $HOME/renewx
rm -rf Microsoft365_E5_Renew_X.zip

if [ -f /usr/local/bin/starte5renewx ]
then 
    echo
else
    sudo chmod 755 -R /usr/local/bin
    sudo echo "export DOTNET_ROOT=$HOME/dotnet &&export PATH=$PATH:$HOME/dotnet && cd $HOME/renewx && sudo dotnet Microsoft365_E5_Renew_X.dll || exit 1" >/usr/local/bin/starte5renewx
    sudo chmod 755 /usr/local/bin/starte5renewx
fi
echo Installation Complete! run <starte5renewx> to start e5renewx.
