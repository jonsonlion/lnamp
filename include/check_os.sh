#!/bin/bash
#-------------------------------------------------------------------------
# Author: MaXincai <maxincai AT 126.com>
# Blog: http://www.maxincai.com
#
# Notes: LANMP for CentOS/RadHat 5+ Debian 6+ and Ubuntu 12+
#
# Github: https://github.com/maxincai/lnamp
#-------------------------------------------------------------------------

if [ -n "`grep 'Aliyun Linux release' /etc/issue`" -o -e /etc/redhat-release ];then
    OS=CentOS
    [ -n "`grep ' 7\.' /etc/redhat-release`" ] && CentOS_RHEL_version=7
    [ -n "`grep ' 6\.' /etc/redhat-release`" -o -n "`grep 'Aliyun Linux release6 15' /etc/issue`" ] && CentOS_RHEL_version=6
    [ -n "`grep ' 5\.' /etc/redhat-release`" -o -n "`grep 'Aliyun Linux release5' /etc/issue`" ] && CentOS_RHEL_version=5
elif [ -n "`grep bian /etc/issue`" -o "`lsb_release -is 2>/dev/null`" == 'Debian' ];then
    OS=Debian
    [ ! -e "`which lsb_release`" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=`lsb_release -sr | awk -F. '{print $1}'`
elif [ -n "`grep Deepin /etc/issue`" -o "`lsb_release -is 2>/dev/null`" == 'Deepin' ];then
    OS=Debian
    [ ! -e "`which lsb_release`" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=`lsb_release -sr | awk -F. '{print $1}'`
elif [ -n "`grep Ubuntu /etc/issue`" -o "`lsb_release -is 2>/dev/null`" == 'Ubuntu' -o -n "`grep 'Linux Mint' /etc/issue`" ];then
    OS=Ubuntu
    [ ! -e "`which lsb_release`" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Ubuntu_version=`lsb_release -sr | awk -F. '{print $1}'`
    [ -n "`grep 'Linux Mint 18' /etc/issue`" ] && Ubuntu_version=16
else
    echo "${CFAILURE}Does not support this OS, Please contact the author! ${CEND}"
    kill -9 $$
fi

if [ `getconf WORD_BIT` == 32 ] && [ `getconf LONG_BIT` == 64 ];then
    OS_BIT=64
    SYS_BIG_FLAG=x64 #jdk
    SYS_BIT_a=x86_64;SYS_BIT_b=x86_64; #mariadb
else
    OS_BIT=32
    SYS_BIG_FLAG=i586
    SYS_BIT_a=x86;SYS_BIT_b=i686;
fi

LIBC_YN=$(awk -v A=`getconf -a | grep GNU_LIBC_VERSION | awk '{print $NF}'` -v B=2.14 'BEGIN{print(A>=B)?"0":"1"}')
[ $LIBC_YN == '0' ] && GLIBC_FLAG=linux-glibc_214 || GLIBC_FLAG=linux

THREAD=$(grep 'processor' /proc/cpuinfo | sort -u | wc -l)
