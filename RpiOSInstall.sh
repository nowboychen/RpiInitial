#!/bin/bash
# Author nowboy
# Date 2021-05-05
# Description:自动安装树莓派系统配置WIFI

#判断当前用户是否root用户，不是则退出
if [ `whoami` != "root" ];then
    echo "请使用root用户运行本脚本！"
    exit 1
fi

#判断TF卡插入
DISK=$(lsblk -Sn --output NAME)
while [ ! $DISK ]
do
    echo "请插入TF卡:"
    sleep 2
    DISK=$(lsblk -Sn --output NAME)
done

#判断有没有输入系统镜像
if [ ${#1} -eq 0 ]; then
#没有下载最新版
    apt update
    apt install -y lynx zip
    #使用官方镜像源下载，速度慢
    #litemirrors=https://downloads.raspberrypi.org/raspios_lite_armhf/images 
     #使用清华镜像源下载，速度快
    litemirrors=https://mirrors.tuna.tsinghua.edu.cn/raspberry-pi-os-images/raspios_lite_armhf/images/
newdir=$(lynx $litemirrors -dump |sed -n '$p'|cut -c 7-) 
newfile=$(lynx $newdir -dump |sed -n '$p'|cut -c 15- |awk -F '/' '{print $NF}' |awk -F '.' '{print $1}') 
wget $newdir$newfile.zip
unzip $newfile.zip
IMAGE=$newfile.img
else
    IMAGE=$1
fi

dd if=$IMAGE of=/dev/$DISK

WIFI_SSID=$(echo '\n\033[32m 请输入您的WIFI名称：\033[0m')
WIFI_PWD=$(echo '\n\033[32m 请输入您的WIFI密码：\033[0m')
    read -p "${WIFI_SSID}" SSID
    read -p "${WIFI_PWD}" PWD

#获取boot分区地址
Boot=$(blkid -L boot)
#挂载boot分区
mount $Boot /media

# 新建ssh空白文件开启ssh服务
touch /media/ssh
# 新建WIFI连接配置文件
touch /media/wpa_supplicant.conf
cat >/media/wpa_supplicant.conf <<EOF
country=CN
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="$SSID"
    psk="$PWD"
    key_mgmt=WPA-PSK
    priority=1
}
EOF
umount /media