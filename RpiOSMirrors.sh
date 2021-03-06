#!/bin/bash
#设置时区上海
timedatectl set-timezone Asia/Shanghai

   echo -e '+---------------------------------------------------+'
    echo -e '|                                                   |'
    echo -e '|   =============================================   |'
    echo -e '|                                                   |'
    echo -e '|       欢迎使用 Linux 一键更换国内软件源脚本       |'
    echo -e '|                                                   |'
    echo -e '|   =============================================   |'
    echo -e '|                                                   |'
    echo -e '+---------------------------------------------------+'
    echo -e ''
    echo -e '#####################################################'
    echo -e ''
    echo -e '            提供以下国内软件源可供选择：'
    echo -e ''
    echo -e '#####################################################'
    echo -e ''
    echo -e ' *  1)    清华大学'
    echo -e ' *  2)   中国科学技术大学'
    echo -e ' *  3)    阿里云'
    echo -e ''
    echo -e '#####################################################'
    echo -e "           系统时间  $(date "+%Y-%m-%d %H:%M:%S")"
    echo -e ''
    echo -e '#####################################################'
    CHOICE_A=$(echo -e '\n\033[32m└ 请选择并输入您想使用的国内源 [ 1~3 ]：\033[0m')
    read -p "${CHOICE_A}" INPUT
    case $INPUT in
    1)
        SOURCE="mirrors.tuna.tsinghua.edu.cn"
        RPISOURCE="mirrors.tuna.tsinghua.edu.cn/raspberrypi"
        ;;
    2)
        SOURCE="mirrors.ustc.edu.cn"
        RPISOURCE="mirrors.ustc.edu.cn/archive.raspberrypi.org/debian"
        ;;
    3)  
        SOURCE="mirrors.aliyun.com"
        RPISOURCE="mirrors.aliyun.com/raspbian/raspbian"
        ;:
    *)
        SOURCE="mirrors.tuna.tsinghua.edu.cn"
        RPISOURCE="mirrors.tuna.tsinghua.edu.cn/raspberrypi"
        echo -e '\n\033[33m---------- 输入错误，将默认使用清华大学作为国内源 ---------- \033[0m'
        sleep 2s
        ;;
    esac

VERSION=$(lsb_release -cs)
#备份
#cp /etc/apt/sources.list /etc/apt/sources.list.bak
#cp /etc/apt/sources.list.d/raspi.list /etc/apt/sources.list.d/raspi.list.bak

#更换源
echo "deb http://${SOURCE}/raspbian/raspbian/ ${VERSION} main non-free contrib rpi" > /etc/apt/sources.list
echo "deb-src http://${SOURCE}/raspbian/raspbian/ ${VERSION} main non-free contrib rpi" >> /etc/apt/sources.list

echo "deb http://${RPISOURCE}/ ${VERSION} main ui" > /etc/apt/sources.list.d/raspi.list
echo "deb-src http://${RPISOURCE}/ ${VERSION} main ui" >> /etc/apt/sources.list.d/raspi.list

#pip换源
#mkdir -p ~/.pip
#touch ~/.pip/pip.conf
#echo "index-url = https://mirrors.aliyun.com/pypi/simple/" > ~/.pip/pip.conf
　　
