#!/bin/bash
#Firefox Hardening
set +e

#Unattended Upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades

#Installs/removes
PACKAGE_INSTALL="acct aide-common apparmor-profiles apparmor-utils auditd debsums gnupg2 apt-listbugs apt-listchanges haveged libpam-apparmor libpam-cracklib libpam-tmpdir needrestart net-tools debian-goodies debsecan fail2ban openssh-server rkhunter sysstat systemd-coredump tcpd update-notifier-common vlock open-vm-tools make unattended-upgrades"
  for deb_install in $PACKAGE_INSTALL; do
    sudo apt-get install -y --no-install-recommends "$deb_install"
  done
PACKAGE_REMOVE="apport* autofs avahi* beep pastebinit popularity-contest rsh* rsync talk* telnet* tftp* whoopsie xinetd yp-tools ypbind"

  for deb_remove in $PACKAGE_REMOVE; do
    sudo apt-get purge -y "$deb_remove"
  done

git clone https://github.com/pyllyukko/user.js.git
cd user.js
make systemwide_user.js
sudo cp /etc/firefox/syspref.js /etc/firefox/syspref.js.bak
sudo cp systemwide_user.js	/etc/firefox/syspref.js
cd ..
#Reinstall Corrupted Packages
sudo apt-get install --reinstall -y $(dpkg -S $(debsums -ac) | cut -d : -f 1 | sort -u) 

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
sudo python3 easier_in.py
echo "do user stuff"
/bin/bash

#AYO FILE PERMS CHECK
chmod 700 /root
chmod 600 /boot/grub/grub.cfg
chown root:root /boot/grub/grub.cfg
chmod og-rwx /boot/grub/grub.cfg

read -p "Apache? (y/n)" APACHE
if [ "$APACHE" = "y" ];
  chmod 750 /etc/apache2/conf* >/dev/null 2>&1
  chmod 511 /usr/sbin/apache2 >/dev/null 2>&1
  chmod 750 /var/log/apache2/ >/dev/null 2>&1
  chmod 640 /etc/apache2/conf-available/* >/dev/null 2>&1
  chmod 640 /etc/apache2/conf-enabled/* >/dev/null 2>&1
  chmod 640 /etc/apache2/apache2.conf >/dev/null 2>&1
fi

chmod -R g-wx,o-rwx /var/log/*

chown root:root /etc/ssh/sshd_config
chmod og-rwx /etc/ssh/sshd_config

chown root:root /etc/passwd
chmod 644 /etc/passwd

chown root:shadow /etc/shadow
chmod o-rwx,g-wx /etc/shadow

chown root:root /etc/group
chmod 644 /etc/group

chown root:shadow /etc/gshadow
chmod o-rwx,g-rw /etc/gshadow

chown root:root /etc/passwd-
chmod 600 /etc/passwd-

chown root:root /etc/shadow-
chmod 600 /etc/shadow-

chown root:root /etc/group-
chmod 600 /etc/group-

chown root:root /etc/gshadow-
chmod 600 /etc/gshadow-

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
