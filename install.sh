#!/bin/bash
# shellcheck disable=SC2024,SC2119,SC2162,SC2120

function start() {
    echo This shell script will install e5renewx on your linux system.
    read -s -n1 -p "press any key to continue ... "
}

function Check_Root() {
  if [[ $EUID -ne 0 ]]; then
    echo "Please use root user tu execute this script"
    exit 1
  fi
}

function Install_Deps() {
    echo starting installation...
    if [ -f /usr/bin/apt-get ]; then
        echo step 1/4 : update software sources
        apt-get update
        apt-get install libc6 libgcc-s1 libgssapi-krb5-2 libssl-dev libstdc++6 zlib1g libgdiplus tar xz-utils zip unzip wget -y
#    elif [ -f /usr/bin/dnf ]; then
#        echo step 1/4 : update software sources
#        dnf update
#        dnf install -y --skip-broken install libgcc openssl libstdc++ zlib libgdiplus tar xz zip unzip wget libstdc++-devel zlib-devel openssl-devel libicu-devel
    else
        echo only support debian and debian-based linux. ; exit 127
    fi
}

function Install_Dotnet() {
    get_arch=$(arch)
    for dotnet in "$HOME"/dotnet*.tar.gz
    do
    if [ -d "$dotnet" ];then
        echo skip download dotnet
    elif [ -d "$HOME"/dotnet ]; then
        echo skip install dotnet 
    elif [[ $get_arch =~ "x86_64" ]]; then
        export dotnet_url=https://download.visualstudio.microsoft.com/download/pr/e89c4f00-5cbb-4810-897d-f5300165ee60/027ace0fdcfb834ae0a13469f0b1a4c8/dotnet-sdk-3.1.426-linux-x64.tar.gz
    elif [[ $get_arch =~ "aarch64" ]]; then
        export dotnet_url=https://download.visualstudio.microsoft.com/download/pr/79f1cf3e-ccc7-4de4-9f4c-1a6e061cb867/68cab78b3f9a5a8ce2f275b983204376/dotnet-sdk-3.1.426-linux-arm64.tar.gz
    elif [[ $get_arch =~ "armhf" ]]; then
        export dotnet_url=https://download.visualstudio.microsoft.com/download/pr/2043e641-977d-43ac-b42a-f47fd9ee79ba/5b10d12a0626adaed720358ab8ad0b7e/dotnet-sdk-3.1.426-linux-arm.tar.gz
    else
        echo "unsupported architecture!!" ; exit 1
     fi
    done

    echo step 2/4 : install dotnet
    wget "$dotnet_url" -O dotnet.tar.gz
    mkdir -p "$HOME"/dotnet
    tar zxf dotnet.tar.gz -C "$HOME"/dotnet
    rm -rf dotnet*.tar.gz
}

function Install_Renewx() {
    if [ -d "$HOME"/renewx/Microsoft365_E5_Renew_X.dll ]; then
        echo skip install renewx
    else
        echo step 3/4 : install e5renewx
        wget https://github.com/dabao1955/e5renewx_onekey_setup/releases/download/archive/renewx.zip
        unzip renewx.zip -d "$HOME"/renewx
        rm -rf renewx.zip
    fi
}

function Link() {
    echo step 4/4 : finish job

    if [ -f /usr/local/bin/starte5renewx ]; then 
        echo "Nothing to do."
    else
        sudo echo "cd $HOME/renewx && sudo $HOME/dotnet/dotnet Microsoft365_E5_Renew_X.dll " > /usr/local/bin/starte5renewx
        sudo chmod 777 /usr/local/bin/starte5renewx
    fi
}

function Install_Success() {
    echo Installation Complete! run /usr/local/bin/starte5renewx to start e5renewx.
}

function main(){
    start
    Check_Root
    Install_Deps
    Install_Dotnet
    Install_Renewx
    Link
    Install_Success
}

main
