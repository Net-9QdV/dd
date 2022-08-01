#!/bin/bash

export LANG=en_US.UTF-8

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
PLAIN="\033[0m"

red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}

yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}

REGEX=("debian" "ubuntu" "centos|red hat|kernel|oracle linux|alma|rocky" "'amazon linux'" "fedora", "alpine")
RELEASE=("Debian" "Ubuntu" "CentOS" "CentOS" "Fedora" "Alpine")
PACKAGE_UPDATE=("apt-get update" "apt-get update" "yum -y update" "yum -y update" "yum -y update" "apk update -f")
PACKAGE_INSTALL=("apt -y install" "apt -y install" "yum -y install" "yum -y install" "yum -y install" "apk add -f")
PACKAGE_REMOVE=("apt -y remove" "apt -y remove" "yum -y remove" "yum -y remove" "yum -y remove" "apk del -f")
PACKAGE_UNINSTALL=("apt -y autoremove" "apt -y autoremove" "yum -y autoremove" "yum -y autoremove" "yum -y autoremove" "apk del -f")

[[ $EUID -ne 0 ]] && red "请在root用户下运行脚本" && exit 1

CMD=("$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)" "$(hostnamectl 2>/dev/null | grep -i system | cut -d : -f2)" "$(lsb_release -sd 2>/dev/null)" "$(grep -i description /etc/lsb-release 2>/dev/null | cut -d \" -f2)" "$(grep . /etc/redhat-release 2>/dev/null)" "$(grep . /etc/issue 2>/dev/null | cut -d \\ -f1 | sed '/^[ ]*$/d')")

for i in "${CMD[@]}"; do
    SYS="$i" && [[ -n $SYS ]] && break
done

for ((int = 0; int < ${#REGEX[@]}; int++)); do
    [[ $(echo "$SYS" | tr '[:upper:]' '[:lower:]') =~ ${REGEX[int]} ]] && SYSTEM="${RELEASE[int]}" && [[ -n $SYSTEM ]] && break
done

[[ -z $SYSTEM ]] && red "不支持当前VPS系统，请使用主流的操作系统" && exit 1

VIRT=$(systemd-detect-virt)
if [[ ! $VIRT == "kvm" ]]; then
    red "DD系统暂时不支持你所选的架构！"
    exit 1
fi

info_bar(){
    clear
    echo "#############################################################"
    echo -e "#                        ${RED}DD 系统脚本${PLAIN}                        #"
    echo -e "# ${GREEN}作者${PLAIN}: taffychan                                           #"
    echo -e "# ${GREEN}GitHub${PLAIN}: https://github.com/taffychan                      #"
    echo "#############################################################"
    echo ""
}

sysinfo(){
    read -rp "请输入系统的root密码 [默认自动生成]：" rootPassword
    read -rp "请输入系统的SSH端口 [默认22]：" sshPort 
}

startdd(){
    bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/taffychan/dd/main/core.sh') \
-${sysType} ${sysVer} \
-v 64 \
-a -firmware \
-p "${rootPassword}" \
-port ${sshPort}
}

oscentos(){
    sysType="c"
    sysVer="6.10"
    sysinfo
    startdd
}

osdebian(){
    info_bar
    yellow "请选择需要DD的系统版本"
    echo -e " ${GREEN}1.${PLAIN} Debian 7"
    echo -e " ${GREEN}2.${PLAIN} Debian 8"
    echo -e " ${GREEN}3.${PLAIN} Debian 9"
    echo -e " ${GREEN}4.${PLAIN} Debian 10"
    echo -e " ${GREEN}5.${PLAIN} Debian 11"
    echo ""
    read -p "请输入选项 [1-5]：" debianChoice
    case $debianChoice info_bar
        1) sysType="d" && sysVer="7" && sysinfo && startdd ;;
        2) sysType="d" && sysVer="8" && sysinfo && startdd ;;
        3) sysType="d" && sysVer="9" && sysinfo && startdd ;;
        4) sysType="d" && sysVer="10" && sysinfo && startdd ;;
        5) sysType="d" && sysVer="11" && sysinfo && startdd ;;
        *) red "请输入正确的选项 [1-5]！" && exit 1 ;;
    esac
}

osubuntu(){
    info_bar
    yellow "请选择需要DD的系统版本"
    echo -e " ${GREEN}1.${PLAIN} Ubuntu 14.04"
    echo -e " ${GREEN}2.${PLAIN} Ubuntu 16.04"
    echo -e " ${GREEN}3.${PLAIN} Ubuntu 18.04"
    echo -e " ${GREEN}4.${PLAIN} Ubuntu 20.04"
    echo ""
    read -p "请输入选项 [1-4]：" ubuntuChoice
    case $ubuntuChoice info_bar
        1) sysType="u" && sysVer="14.04" && sysinfo && startdd ;;
        2) sysType="u" && sysVer="16.04" && sysinfo && startdd ;;
        3) sysType="u" && sysVer="18.04" && sysinfo && startdd ;;
        4) sysType="u" && sysVer="20.04" && sysinfo && startdd ;;
        *) red "请输入正确的选项 [1-4]！" && exit 1 ;;
    esac
}

menu(){
    info_bar
    yellow "请选择需要DD的系统"
    echo -e " ${GREEN}1.${PLAIN} CentOS"
    echo -e " ${GREEN}2.${PLAIN} Debian"
    echo -e " ${GREEN}3.${PLAIN} Ubuntu"
    echo ""
    read -rp "请输入选项 [1-3]：" menuChoice
    case $menuChoice in:
        1) oscentos ;;
        2) osdebian ;;
        3) osubuntu ;;
        *) red "请输入正确的选项 [1-3] ！" && exit 1 ;;
    esac
}

menu
