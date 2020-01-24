#!/bin/bash
#Firefox Hardening
git clone https://github.com/pyllyukko/user.js.git
cd user.js
make systemwide_user.js
sudo cp /etc/firefox/syspref.js /etc/firefox/syspref.js.bak
sudo cp systemwide_user.js	/etc/firefox/syspref.js
cd ..
#Installs/removes
PACKAGE_INSTALL="acct aide-common apparmor-profiles apparmor-utils auditd debsums gnupg2 apt-listbugs apt-listchanges haveged libpam-apparmor libpam-cracklib libpam-tmpdir needrestart debian-goodies debsecan fail2ban openssh-server rkhunter sysstat systemd-coredump tcpd update-notifier-common vlock open-vm-tools"
  for deb_install in $PACKAGE_INSTALL; do
    sudo apt-get install -y --no-install-recommends "$deb_install"
  done
PACKAGE_REMOVE="apport* autofs avahi* beep pastebinit popularity-contest rsh* rsync talk* telnet* tftp* whoopsie xinetd yp-tools ypbind"

  for deb_remove in $PACKAGE_REMOVE; do
    sudo apt-get purge -y "$deb_remove"
  done

#Config File Drops
git clone https://github.com/cstallar/secure-debian-configs
cd secure-debian-configs
for f in $(find . -type f | grep etc | cut -c 3-)
do
  sudo cp /$f /$f.bak
  sudo cp $(pwd)/$f /$f
done
cd ..

#User interactive session
echo "User Shells:"
cut -d: -f1,7 /etc/passwd
echo "Make required changes"
/bin/bash
echo "Network Connnections (netstat -tulpn):"
sudo netstat -tulpn
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
