#!/bin/bash

# This script enables the user to deploy Arch Linux rather quick

HOSTNAME=sandy
USERNAME=lafriedrichsen

echo "1 -> Installing Arch"
echo "2 -> Installing programms"

read MENU;

case $MENU in

1)

echo "--- PING ---"
ping c- 3 8.8.8.8

cfdisk

echo "--- CREATING FS ---"
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3

echo "--- MOUNTING DEVICES ---"
mount /dev/sda1 /mnt
mkdir /mnt/home
mount /dev/sda2 /mnt/home

nano /etc/pacman.d/mirrorlist

pacstrap -i /mnt base base-devel

genfstab -U -p /mnt >> /mnt/etc/fstab

arch-chroot /mnt

nano /etc/locale.gen
echo LANG=de_DE.UTF-8 > /etc/locale.conf
export LANG=de_DE.UTF-8

ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc --utc

echo $HOSTNAME > /etc/hostname

nano /etc/pacman.conf
pacman -Syy

passwd
useradd -m -g users -G wheel,power,storage -s /bin/bash $USERNAME
passwd $USERNAME

EDITOR=nano visudo

pacman -S bash-completion

pacman -S grub
grub-install --target=i386-pc --recheck /dev/sda

pacman -S os-prober

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable dhcpcd.service
systemctl start dhcpcd.service

exit

umount -R /mnt

echo "Type reboot to restart your machine";;

2)

su -
pacman -S xorg-server xorg-server-utils xorg-xinit mesa
pacman -S nvidia lib32-nvidia-utils
pacman -S lxdm i3 xterm thunar thunar-archive-plugin thunar-volman xfce4-terminal tmux vim ranger cmus finch firefox dmenu 
pacman -S sshfs samba gvfs fuseiso
systemctl enable lxdm.service
nvidia-xconfig

echo "reboot to run you ready to go system";;

esac
