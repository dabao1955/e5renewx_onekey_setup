#!/usr/bin/env bash
# Shellcheck directives
# shellcheck disable=SC2024,SC2119,SC2162,SC2120

echo "This shell script will install e5renewx on your Linux system."
read -r -n1 -p "Press any key to continue ... " 
echo

check_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "You must run this script with sudo."
    exit 1
  fi
}

install_deps() {
    echo "Starting installation..."
    if command -v apt-get > /dev/null; then
        echo "Step 1/4 : Updating software sources"
        sudo apt-get update
        sudo apt-get install libc6 libgcc-s1 libgssapi-krb5-2 libssl-dev libstdc++6 zlib1g libgdiplus tar xz-utils zip unzip wget -y
    else
        echo "This script supports Debian and Debian-based distributions only."
        exit 127
    fi
}

install_dotnet() {
    local arch=$(uname -m)
    local dotnet_url=""
    echo "Step 2/4 : Installing dotnet"
    case $arch in
    "x86_64") dotnet_url=https://download.visualstudio.microsoft.com/download/pr/e89c4f00-5cbb-4810-897d-f5300165ee60/027ace0fdcfb834ae0a13469f0b1a4c8/dotnet-sdk-3.1.426-linux-x64.tar.gz ;;
    "aarch64") dotnet_url=https://download.visualstudio.microsoft.com/download/pr/79f1cf3e-ccc7-4de4-9f4c-1a6e061cb867/68cab78b3f9a5a8ce2f275b983204376/dotnet-sdk-3.1.426-linux-arm64.tar.gz ;;
    "armhf") dotnet_url=https://download.visualstudio.microsoft.com/download/pr/2043e641-977d-43ac-b42a-f47fd9ee79ba/5b10d12a0626adaed720358ab8ad0b7e/dotnet-sdk-3.1.426-linux-arm.tar.gz ;;
    *) echo "Unsupported architecture!!" ; exit 1 ;;
    esac

    wget -nv "$dotnet_url" -O dotnet.tar.gz
    mkdir -p "$HOME"/dotnet
    tar zxf dotnet.tar.gz -C "$HOME"/dotnet
    rm -f dotnet.tar.gz
}

install_renewx() {
    echo "Step 3/4 : Installing e5renewx"
    if [ ! -d "$HOME/renewx" ]; then
        wget -nv https://github.com/dabao1955/e5renewx_onekey_setup/releases/download/archive/renewx.zip
        unzip -q renewx.zip -d "$HOME"/renewx
        rm -f renewx.zip
    else
        echo "RenewX is already installed."
    fi
}

link() {
    echo "Step 4/4 : Finalizing installation"
    if [ ! -f /usr/local/bin/starte5renewx ]; then 
        echo "cd $HOME/renewx && $HOME/dotnet/dotnet Microsoft365_E5_Renew_X.dll" | sudo tee /usr/local/bin/starte5renewx > /dev/null
        sudo chmod +x /usr/local/bin/starte5renewx
    else
        echo "starte5renewx is already available."
    fi
}

install_success() {
    echo "Installation Complete! Run /usr/local/bin/starte5renewx to start e5renewx."
}

main() {
    check_root
    install_deps
    install_dotnet
    install_renewx
    link
    install_success
}

main "$@"