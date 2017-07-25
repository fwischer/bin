!#/bin/bash
# Raspberry Pi 3 Setup Script
# Flawless shitScript by Florian Wischer
# 3 Keypresses for a Full on Dashboard PI
# give the PI a Hostname at the end of the script and give him the right locale at the start.
# 22.06.2017

Key1="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCdW2sN7oIMTU5LCFgKoMxRX3sbDUgU3O17IIjrvmo9/hp9EvNRk6ZXVsKO5Ym+IqHkDwZYqgsPN060Lh14NK3IZlUv1GubjbLCao5uqpSdcVH+JKhCRBIZdNav3M3aj2Wcd0Y9DL3rKFCRlNi7/DklHerpDmpAStcPzbfXIuwaxgl+6GdILz4dWTpC3sMHWlCN0I0gVxil5uHU9WMlz+wwv7jxQUA0cXlHMt658zLjtJrW0JjbYK5em3u3te8mexpVDbtdUy7mfgGChQaMbz9YfliUdx8JQ0KAyIZ8c5tUIifAoCiiIahWV9SaEOL3+Cegy+GFwh4U+7EV/VJRnIX95SFy89ghfDkap6KgOVVAjxbUZo8BlF+siGkxmyHiiWOVTPd+SDSIqpvzLjxSe45BUdkAGQbjwBhT4fqCZET493aBBXnN4owM81MYN1/G5Z5R8xD1bX65+oBLOy2fkKc/RAeTjiaIyvUC4zLKmqvQFSFh8AHrP4gDsM//ckcjfogFqLVwKYTuJU2JpUmBiriv3tppNjk1bH6Odo0Yh6QtTlT5kEz0bY+QGsF1MdWEpCiAdda8iDIFLNMYteLiHVTAXqrgkTxgYoppLTDBFCjm9ghbxLILYQWFQoIhcr/KrnMZzB2qk45BOB2bzhfuEN7MeUgp/h56+uKS8+LOE0nr0w== florian.wischer@magicline.de" 
Key2="5olwB/WrUC4HZEW0YTYTaV3d5t333AX7orPuPhi3GSyw8uFplx8986P3jx2l9gYAYkzmiAe5ivzdP7xcHikAB2A7HVCRpxtMpdDNgTl+cEhQ3tSIowJ5TSzeK4ntmShrWg1nZ3kp4nkn0w8qjDyLevdrkbZPVZ+tITgIUxa3dtRQ7g5Ih4APNI57ccOwEKgwnmNzXNiOokk9M88cx43yVJ9SFpD5WRbWu1vzk8JwJVanlqCeXgBK7BrDP03PZ6jSYu9KkAeZT2hlVwBICFt Johannes Matjeschk"

USERMOD='-s /bin/sh pi'

echo "TZ='Europe/Berlin'; export TZ" >>.profile

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales


su -c "mkdir -p .ssh/" $USERMOD
su -c "touch .ssh/authorized_keys" $USERMOD
su -c "echo $Key1 >> .ssh/authorized_keys" $USERMOD
su -c "echo $Key2 >> .ssh/authorized_keys" $USERMOD
su -c "chmod -R go-rwx .ssh" $USERMOD

#Updating and installing programms needed for Kioskmode

apt-get -y update
echo "q" | apt-get -y upgrade
apt-get install -y x11-xserver-utils unclutter ntp ntpdate tightvncserver cron-apt bash-completion vim x11vnc cec-utils xinetd

#Installing Chromium for Pi

wget http://ftp.us.debian.org/debian/pool/main/libg/libgcrypt11/libgcrypt11_1.5.0-5+deb7u4_armhf.deb
dpkg -i libgcrypt11_1.5.0-5+deb7u4_armhf.deb
rm libgcrypt11_1.5.0-5+deb7u4_armhf.deb

wget http://launchpadlibrarian.net/218525711/chromium-codecs-ffmpeg-extra_45.0.2454.85-0ubuntu0.14.04.1.1097_armhf.deb
dpkg -i chromium-codecs-ffmpeg-extra_45.0.2454.85-0ubuntu0.14.04.1.1097_armhf.deb
rm chromium-codecs-ffmpeg-extra_45.0.2454.85-0ubuntu0.14.04.1.1097_armhf.deb

wget wget http://launchpadlibrarian.net/218525709/chromium-browser_45.0.2454.85-0ubuntu0.14.04.1.1097_armhf.deb
dpkg -i chromium-browser_45.0.2454.85-0ubuntu0.14.04.1.1097_armhf.deb
rm chromium-browser_45.0.2454.85-0ubuntu0.14.04.1.1097_armhf.deb

wget http://epona.ad.loyaltysystems.biz/lys_prd/check_mk/agents/check-mk-agent_1.2.6p12-1_all.deb
dpkg -i check-mk-agent_1.2.6p12-1_all.deb
rm check-mk-agent_1.2.6p12-1_all.deb

apt-get dist-upgrade -f -y

#adding NTP server and deleting the old ones

sed -i '10idisable_overscan=1' /boot/config.txt
sed -i '29ihdmi_group=1' /boot/config.txt
sed -i '31ihdmi_mode=16' /boot/config.txt
sed -i '17ilink.ad.loyaltysystems.biz iburst' /etc/ntp.conf
sed -i '/server 1.debian.pool.ntp.org iburst/d' /etc/ntp.conf
sed -i '/server 2.debian.pool.ntp.org iburst/d' /etc/ntp.conf
sed -i '/server 3.debian.pool.ntp.org iburst/d' /etc/ntp.conf
sed -e s/-d//g -i /etc/cron-apt/action.d/3-download

#adding Autostart for VNC

su -c "mkdir -p ~/.config/autostart" $USERMOD
su -c "echo    '[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=X11VNC
Comment=
Exec=x11vnc -forever -usepw -display :0 -ultrafilexfer
StartupNotify=false
Terminal=false
Hidden=false' > ~/.config/autostart/x11vnc.desktop" $USERMOD

#adding chromium Sites 

su -c "echo '@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi
@xset s off
@xset -dpms
@xset s noblank
@sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' ~/.config/chromium/Default/Preferences
@sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/Default/Preferences' > ~/.config/lxsession/LXDE-pi/autostart" $USERMOD

x11vnc -storepasswd

echo 'Hostnamen eingeben: '

read varname

echo $varname > /etc/hostname

/bin/echo "on 0" | /usr/bin/cec-client -s -d 1 > /dev/null

reboot
