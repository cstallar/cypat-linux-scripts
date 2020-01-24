#!/bin/bash
#Firefox Hardening
git clone https://github.com/pyllyukko/user.js.git
cd user.js
make systemwide_user.js
sudo mv /etc/firefox-esr/firefox-esr.js /etc/firefox-esr/firefox-esr.js.bak
sudo mv systemwide_user.js	/etc/firefox-esr/firefox-esr.js
#Config File Drops
git clone https://github.com/cstallar/secure-debian-configs
cd secure-debian-configs
for f in $(find . | cut -c 3-)
do
  sudo mv /$f /$f.bak
  sudo cp $(pwd)/$f /$f
done
cd ..
local PACKAGE_INSTALL
  PACKAGE_INSTALL="acct aide-common apparmor-profiles apparmor-utils auditd debsums gnupg2 haveged libpam-apparmor libpam-cracklib libpam-tmpdir needrestart openssh-server rkhunter sysstat systemd-coredump tcpd update-notifier-common vlock open-vm-tools"

  for deb_install in $PACKAGE_INSTALL; do
    $APT install --no-install-recommends "$deb_install"
  done
local PACKAGE_REMOVE
  PACKAGE_REMOVE="apport* autofs avahi* beep git pastebinit popularity-contest rsh* rsync talk* telnet* tftp* whoopsie xinetd yp-tools ypbind"

  for deb_remove in $PACKAGE_REMOVE; do
    $APT purge "$deb_remove"
  done
#User interactive session
echo "User Shells:"
cut -d: -f1,7 /etc/passwd
echo "Make required changes"
/bin/bash
echo "Network Connnections (netstat -tulpn):"
netstat -tulpn
echo "Make required changes"
/bin/bash
echo "Configure UFW"
/bin/bash
echo "Services"
sudo service --status-all
echo "Make required changes"
/bin/bash
echo "Set check for updates to daily in GUI (Press enter to continue)"
read
echo "Remove any stupid programs (games, etc) that are installed"
/bin/bash

sudo apt update
sudo apt dist-upgrade
