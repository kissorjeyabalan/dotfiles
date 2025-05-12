#!/bin/bash
clear

# Meta folder
meta_folder = "$HOME/.baremetal"

pkg_installed() {
    local PkgIn=$1
    if pacman -Qi "${PkgIn}" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

pkg_available() {
    local PkgIn=$1
    if pacman -Si "${PkgIn}" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

aur_available() {
    local PkgIn=$1
    if yay -Si "${PkgIn}" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

prompt_timer() {
    set +e
    unset promptIn
    local timsec=$1
    local msg=$2
    while [[ ${timsec} -ge 0 ]]; do
        echo -ne "\r :: ${msg} (${timsec}s) : "
        read -t 1 -n 1 promptIn
        [ $? -eq 0 ] && break
        ((timsec--))
    done
    export promptIn
    echo ""
    set -e
}

# Create meta_folder if it doesn't exist
if [ ! -d "$meta_folder" ]; then
    mkdir -p "$meta_folder"
fi

# Check if command exists
command_exists() {
    package = "$1"
    if ! command -v $package >/dev/null; then
        return 1 # Command does not exist
    else
        return 0 # Command exists
    fi
}

# Install required packages
install_packages() {
    toInstall = ()
    for pkg; do
        if [[ $(is_installed "${pkg}") == 0 ]]; then
            echo -e "\033[0;33m[skip]\033[0m ${pkg} is already installed..."
        else
            toInstall+=("${pkg}")
        fi
    done
    if [[ "${toInstall[@]}" == "" ]]; then
        return
    fi
    printf "Package not installed:\n%s\n" "${toInstall[@]}"
    sudo pacman --noconfirm -S "${toInstall[@]}"
}

# Install yay if not installed
install_yay() {
    install_packages "base-devel git"
    SCRIPT = $(realpath "$0")
    temp_path = $(dirname "$SCRIPT")
    git clone https://aur.archlinux.org/yay.git "$meta_folder/yay"
    cd $meta_folder/yay
    makepkg -si
    cd $temp_path
    echo ":: yay installed"
}

# Read all lines from given file and put it into a list. Ignore comments and empty lines.
read_list() {
    file="$1"
    lines=()
    while IFS= read -r line; do
        # Remove comments starting with # and trim whitespace
        line=$(echo "$line" | sed 's/#.*//' | xargs)
        if [[ -z $line ]]; then
            continue
        fi
        lines+=("$line")
    done <"$file"
    echo "${lines[@]}"
}

packages=$(read_packages "packages.lst")

# Colors
NONE='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'

# Header
echo -e "${GREEN}"
echo "Running install script..."
echo -e "${NONE}"

while true; do
    read -p "Do you want to start the installation? (Yy/Nn): " yn
    case $yn in
        [Yy]*)
            echo ":: Installation started."
            echo
            break
            ;;
        [Nn]*)
            echo ":: Installation aborted."
            exit 0
            break
            ;;
        *)
            echo "Please answer yes or no."
            ;;
    esac
done

# Create meta folder if it doesn't exist
if [ ! -d "$meta_folder" ]; then
    mkdir -p "$meta_folder"
fi

# Synchronize package databases
sudo pacman -Sy
echo

# Install required packages
printf ":: Checking that required packages are installed...\n"

# Install yay if not installed

archPkg = ()
aurhPkg = ()

if command_exists "yay"; then
    printf "\033[0;33m[skip]\033[0m ${pkg} is already installed...\n"
else
    printf "\033[0;32m[git]\033[0m queueing ${pkg} from git\n"
    install_yay
fi
echo

# Loop through every package in packages variable
for pkg in ${packages[@]}; do
    if pkg_installed "${pkg}"; then
        printf "\033[0;33m[skip]\033[0m ${pkg} is already installed...\n"
    elif pkg_available "${pkg}"; then
        #repo=$(pacman -Si "${pkg}" | awk -F ': ' '/Repository / {print $2}')
        printf "\033[0;32m[${repo}]\033[0m queueing ${pkg} from official arch repo...\n"
        archPkg+=("${pkg}")
    elif aur_available "${pkg}"; then
        printf "\033[0;34m[aur]\033[0m queueing ${pkg} from arch user repo...\n"
        aurhPkg+=("${pkg}")
    else
        printf "Error: unknown package ${pkg}...\n"
    fi
done

if [[ ${#archPkg[@]} -gt 0 ]]; then
    sudo pacman --noconfirm -S "${archPkg[@]}"
fi

if [[ ${#aurhPkg[@]} -gt 0 ]]; then
    yay --noconfirm -S "${aurhPkg[@]}"
fi

# to make command-not-found work
sudo pkgfile -u
sudo systemctl enable --now pkgfile-update.timer # Enable automatic updates https://wiki.archlinux.org/title/Pkgfile#Automatic_updates