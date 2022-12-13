#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Browsers\n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if ! package_is_installed "vivaldi-stable"; then

    wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor | sudo dd of=/usr/share/keyrings/vivaldi-browser.gpg &> /dev/null \
        || print_error "Vivaldi Stable (add key)"
    
    echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" | sudo dd of=/etc/apt/sources.list.d/vivaldi-archive.list &> /dev/null \
        || print_error "Vivaldi Stable (add to package resource list)"

    update &> /dev/null \
        || print_error "Vivaldi Stable (resync package index files)"

fi

install_package "Vivaldi Stable" "vivaldi-stable"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

printf "\n"

if ! package_is_installed "firefox-trunk"; then

    add_ppa "ubuntu-mozilla-daily/ppa" \
        || print_error "Firefox Nightly (add PPA)"

    update &> /dev/null \
        || print_error "Firefox Nightly (resync package index files)"

fi

install_package "Firefox Nightly" "firefox-trunk"
