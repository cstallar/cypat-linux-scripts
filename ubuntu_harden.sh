#!/bin/bash
#Firefox Hardening
set +e

#Unattended Upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades

#Installs/removes
PACKAGE_INSTALL="acct aide-common apparmor-profiles apparmor-utils auditd debsums gnupg2 apt-listbugs apt-listchanges haveged libpam-apparmor libpam-cracklib libpam-tmpdir needrestart net-tools debian-goodies debsecan fail2ban openssh-server rkhunter sysstat systemd-coredump tcpd update-notifier-common vlock open-vm-tools make tree unattended-upgrades"
  for deb_install in $PACKAGE_INSTALL; do
    sudo apt-get install -y --no-install-recommends "$deb_install"
  done
PACKAGE_REMOVE="apport* autofs avahi* beep pastebinit popularity-contest rsh* rsync talk* telnet* tftp* whoopsie xinetd yp-tools ypbind"

  for deb_remove in $PACKAGE_REMOVE; do
    sudo apt-get purge -y "$deb_remove"
  done

#Reinstall Corrupted Packages
sudo apt-get install --reinstall -y $(sudo dpkg -S $(sudo debsums -ac) | cut -d : -f 1 | sort -u) 

git clone https://github.com/pyllyukko/user.js.git
cd user.js
make systemwide_user.js
sudo cp /etc/firefox/syspref.js /etc/firefox/syspref.js.bak
sudo cp systemwide_user.js	/etc/firefox/syspref.js
cd ..

#Config File Drops
git clone https://github.com/cstallar/secure-debian-configs
cd secure-debian-configs
for f in $(find . -type f | grep etc | cut -c 3-)
do
  sudo cp /$f /$f.bak
  sudo cp $(pwd)/$f /$f
done
cd ..
#Python script
#sudo python3 easier_in.py
echo "do user stuff"
/bin/bash

#AYO FILE PERMS CHECK
sudo chmod 700 /root
sudo chmod 600 /boot/grub/grub.cfg
sudo chown root:root /boot/grub/grub.cfg
sudo chmod og-rwx /boot/grub/grub.cfg

sudo chmod -R g-wx,o-rwx /var/log/*

sudo chown root:root /etc/ssh/sshd_config
sudo chmod og-rwx /etc/ssh/sshd_config

sudo chown root:root /etc/passwd
sudo chmod 644 /etc/passwd

sudo chown root:shadow /etc/shadow
sudo chmod o-rwx,g-wx /etc/shadow

sudo chown root:root /etc/group
chmod 644 /etc/group

sudo chown root:shadow /etc/gshadow
sudo chmod o-rwx,g-rw /etc/gshadow

sudo chown root:root /etc/passwd-
sudo chmod 600 /etc/passwd-

sudo chown root:root /etc/shadow-
sudo chmod 600 /etc/shadow-

sudo chown root:root /etc/group-
sudo chmod 600 /etc/group-

sudo chown root:root /etc/gshadow-
sudo chmod 600 /etc/gshadow-

#User interactive session
echo "Enable updates from all sources (press enter to continue)"
read
echo "Network Connnections (netstat -tulpn):"
sudo netstat -tulpn
echo "Make required changes"
/bin/bash
echo "Services"
sudo service --status-all
echo "Make required changes"
/bin/bash
echo "Remove any stupid programs (games, etc) that are installed"
/bin/bash

sudo passwd -l root
sudo apt update
sudo apt dist-upgrade
echo "Try updating from GUI now (because reasons). "
