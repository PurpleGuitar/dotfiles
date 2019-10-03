#!/usr/bin/env bash

# ============
# WSL Wizardry
# ============
# If running under WSL2, source this file to get some useful functions in bash

function wsl-display() {
    # Lookup host display from PowerShell
    export DISPLAY=$( \
        powershell.exe 'gwmi win32_NetworkAdapterConfiguration -Filter "IPEnabled=True and DHCPEnabled=True and DNSDomain is not null" | Format-List -Property *' \
        | grep IPAddress \
        | grep --only-matching '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' \
        ):0.0
    echo DISPLAY=${DISPLAY}
}

function wsl-dns() {
    # Lookup host DNS from PowerShell
    export WSL_HOST_DNS=$( \
        powershell.exe 'gwmi win32_NetworkAdapterConfiguration -Filter "IPEnabled=True and DHCPEnabled=True and DNSDomain is not null" | Format-List -Property *' \
        | grep DNSServerSearchOrder \
        | grep --only-matching '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' \
        | head -n 1
        )
    echo WSL_HOST_DNS=${WSL_HOST_DNS}
    echo "Attempting to update /etc/resolv.conf..."
    sudo sed -i.bak -e "s/^nameserver .*/nameserver ${WSL_HOST_DNS}/" /etc/resolv.conf
}

# vim: set foldmethod=indent
