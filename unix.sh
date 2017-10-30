#!/bin/bash

function sysconf_centos {
clear
osver=7
[ $(getconf LONG_BIT) = '64' ] || (echo "Your System isn't 64bit which we want it to be!"; return)
[ -e /etc/centos-release ] && cat /etc/centos-release | grep 6\\. >/dev/null && echo 'version: CentOS 6' && osver=6 || echo 'version: CentOS 7'

# install font: consolas
if [ ! -e /usr/share/fonts/msfonts  ]; then
    echo -e '\n\e[32mInstall fonts\e[m';sleep 1
    mkdir /usr/share/fonts/msfonts
    cp  cfg_unix/*.ttf /usr/share/fonts/msfonts 2>/dev/null
    fc-cache -f
fi
# install common command
rm -rf /usr/share/vim 2>/dev/null
rm -f /usr/bin/{ex,rview,rvim,view,vim*} 2>/dev/null
rm -f ~/.zcompdump* 2>/dev/null
mkdir -p /usr/local/share/vim 2>/dev/null
\cp -pf cfg_unix/rm.sh /usr/local/bin/rm 2>/dev/null && chmod +x /usr/local/bin/rm 2>/dev/null
\cp -pf cfg_unix/shc /usr/local/bin 2>/dev/null && chmod +x /usr/local/bin/shc 2>/dev/null
\cp -pf cfg_unix/.vimrc ~/ 2>/dev/null
\cp -pf cfg_unix/.zshrc ~/ 2>/dev/null
\cp -pf cfg_unix/.bashrc ~/ 2>/dev/null
\cp -pf cfg_unix/.tmux.conf ~/ 2>/dev/null
\cp -fp cfg_unix/zsh /usr/local/bin/ 2>/dev/null && chmod +x /usr/local/bin/zsh 2>/dev/null
\cp -pf cfg_unix/vim /usr/local/bin/ 2>/dev/null && chmod +x /usr/local/bin/vim 2>/dev/null
\cp -pf cfg_unix/vimtutor /usr/local/bin/ 2>/dev/null && chmod +x /usr/local/bin/vimtutor 2>/dev/null
[ -e /usr/local/share/zsh/5.0.8 ] || tar -xf cfg_unix/zsh.tar -C /usr/local/share/ 2>/dev/null
[ -e /usr/local/share/vim/.NERDTreeBookmarks ] || \cp -rpf cfg_unix/vim-linux/* /usr/local/share/vim 2>/dev/null

# set timezone
echo -e '\n\e[32mSet Timezone to Shanghai and update time\e[m';sleep 1
printf 'ZONE="Asia/Shanghai"\nUTC=false\nARC=false' > /etc/sysconfig/clock
ntpdate cn.pool.ntp.org && hwclock -w

# disable selinux
echo -e '\n\e[32mDisable SELinux\e[m';sleep 1
setenforce 0
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/sysconfig/selinux
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config 2>/dev/null

# press C-S-A-delete will restart, disable it!
echo -e '\n\e[32mDisable Ctrl-Shift+Alt+Delete to shutdown\e[m';sleep 1
sed -i 's#exec /sbin/shutdown -r now#\#exec /sbin/shutdown -r now#' /etc/init/control-alt-delete.conf

# limit the max number of simultaneous login
echo -e '\n\e[32mLimit the maximum number of simultaneous login\e[m';sleep 1
echo "* hard maxsyslogins 6" >> /etc/security/limits.conf

# reduce the number of tty
echo -e '\n\e[32mReduce the number of tty\e[m';sleep 1
sed -i 's|ACTIVE_CONSOLES=/dev/tty\[1-6\]|ACTIVE_CONSOLES=/dev/tty\[1-2\]|' /etc/init/start-ttys.conf
sed -i 's|ACTIVE_CONSOLES=/dev/tty\[1-6\]|ACTIVE_CONSOLES=/dev/tty\[1-2\]|' /etc/sysconfig/init

# speed up ssh login
echo -e '\n\e[32mSpeed up ssh login\e[m';sleep 1
sed -i 's/^GSSAPIAuthentication yes/GSSAPIAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config

sleep 1

# disable some service
echo -e '\n\e[32mDisable some Service\e[m';sleep 1
sleep 1
if [ "$osver" = "7" ]; then
    svr=(firewalld bluetooth dbus-org.bluez vmtoolsd multipathd mdmonitor)
    svr=(${svr} abrtd abrt-ccpp abrt-oops abrt-vmcore abrt-xorg)
    svr=(${svr} auditd kdump lvm2-monitor postfix rngd smartd)
    svr=(${svr} NetworkManager-dispatcher NetworkManager avahi-daemon)
    svr=(${svr} microcode multipathd)
    for s in ${svr[*]}; do
        systemctl stop $s
        systemctl disable $s
    done
elif [ "$osver" = "6" ]; then
    for svr in `chkconfig --list | grep 3:on| awk '{print $1}'`; do
        chkconfig --level 3 $svr off 2>/dev/null
    done
    for svr in atd crond cpuspeed irqbalance messagebus network rsyslog sshd; do
        chkconfig --level 3 $svr on 2>/dev/null
    done
fi

# optimize network
echo -e '\n\e[32mOptimize network parameters\e[m';sleep 1
if ! grep -iq net.ipv4.tcp_tw_reuse /etc/sysctl.conf; then
    echo -e "\n# optimize network" >> /etc/sysctl.conf
    cat >> /etc/sysctl.conf << EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_syncookies = 1
net.core.somaxconn = 262144
EOF
fi

#
# Add Personal configure to bashrc
#
#grep -q asciiquarium ~/.bashrc || echo "alias aqua='asciiquarium'" >>~/.bashrc
#grep -q "yum install" ~/.bashrc || echo "alias si='yum install'" >>~/.bashrc
#grep -q "setterm -blank" ~/.bashrc || echo "setterm -blank 0" >>~/.bashrc
#grep -q "PS1=" ~/.bashrc || echo "PS1=\"[\\[\\e[32m\\]\\t \\[\\e[33m\\]\\u \\[\\e[35m\\]\\w\\[\\e[m\\]]\\\\$ \"" >>~/.bashrc
if [ ! -e /etc/DIR_COLORS.bak  ]; then
    mv /etc/DIR_COLORS /etc/DIR_COLORS.bak
    sed 's/DIR 01;34/DIR 01;35/' /etc/DIR_COLORS.bak >/etc/DIR_COLORS
fi

#
# config software repository, be aware of the URL is case sensitive!
# epel may be blocked by GFW!!!
#
echo -e '\n\e[32mAdd some software-repositories\e[m';sleep 2
sleep 1
rpm_epel="https://dl.fedoraproject.org/pub/epel/epel-release-latest-${osver}.noarch.rpm"
rpm_remi="http://rpms.remirepo.net/enterprise/remi-release-${osver}.rpm"
rpm_forge="http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el${osver}.rf.x86_64.rpm"
rpm -qa | grep epel >/dev/null || rpm -ivh ${rpm_epel}
rpm -qa | grep remi >/dev/null || rpm -ivh ${rpm_remi}
rpm -qa | grep rpmforge >/dev/null || rpm -ivh ${rpm_forge}
[ $osver = 6 ] && rpm -qa | grep rpmfusion.* >/dev/null || rpm -ivh http://download1.rpmfusion.org/free/el/updates/6/i386/rpmfusion-free-release-6-1.noarch.rpm
rpm --import http://rpms.remirepo.net/RPM-GPG-KEY-remi
rpm --import http://dag.wieers.com/packages/RPM-GPG-KEY.dag.txt
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY*
# configure repo priorities
rpm -qa | grep yum-plugin-priorities >/dev/null || yum -y install yum-plugin-priorities
if [ ! -e /etc/yum.repos.d/CentOS-Base.repo.bak ]; then
	cp -f /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak 2>/dev/null
	sed -i '/^gpgkey/a\priority=1' /etc/yum.repos.d/CentOS-Base.repo 2>/dev/null
fi
if [ ! -e /etc/yum.repos.d/epel.repo.bak ]; then
	cp -f /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.bak 2>/dev/null
	sed -i '/^gpgkey/a\priority=11' /etc/yum.repos.d/epel.repo 2>/dev/null
fi
if [ ! -e /etc/yum.repos.d/remi.repo.bak ]; then
	cp -f /etc/yum.repos.d/remi.repo /etc/yum.repos.d/remi.repo.bak 2>/dev/null
	sed -i 's/^enabled=0/enabled=1/' /etc/yum.repos.d/remi.repo 2>/dev/null
	sed -i '/^gpgkey/a\priority=12' /etc/yum.repos.d/remi.repo 2>/dev/null
fi
if [ ! -e /etc/yum.repos.d/rpmforge.repo.bak ]; then
	cp -f /etc/yum.repos.d/rpmforge.repo /etc/yum.repos.d/rpmforge.repo.bak 2>/dev/null
	sed -i '/^gpgkey/a\priority=13' /etc/yum.repos.d/rpmforge.repo 2>/dev/null
fi
if [ ! -e /etc/yum.repos.d/rpmfusion-free-updates.repo.bak ]; then
	cp -f /etc/yum.repos.d/rpmfusion-free-updates.repo /etc/yum.repos.d/rpmfusion-free-updates.repo.bak 2>/dev/null
	sed -i '/^gpgkey/a\priority=14' /etc/yum.repos.d/rpmfusion-free-updates.repo 2>/dev/null
fi
rm -f /etc/yum.repos.d/{epel-testing.repo,mirrors*,remi-*,rpmfusion-free-updates-testing.repo} 2>/dev/null
yum makecache

#
# install common software!
#
echo -e '\n\e[32mInstall common software\e[m';sleep 2
sleep 1
# install pre-requisite package
yum groupinstall "Development tools" >/dev/null 2>/dev/null
rpm -qa | grep libevent >/dev/null && yum -y remove libevent
if [ ! -e /usr/lib64/libevent-2.0.so.5 ]; then
    echo -e '\n\e[32mInstall libevent-2.0\e[m'
    ok=0
    wget http://superb-dca2.dl.sourceforge.net/project/levent/libevent/libevent-2.0/libevent-2.0.22-stable.tar.gz
    [ -e libevent-2.0.22-stable.tar.gz ] && tar -xf libevent-2.0.22-stable.tar.gz && cd libevent-2.0.22-stable && ./configure >/dev/null && make >/dev/null && make install >/dev/null && ok=1
    cd ..
    rm -fr libevent* 2>/dev/null
    [ $ok == 1 ] && ln -s /usr/local/lib/libevent-2.0.so.5 /usr/lib64/libevent-2.0.so.5 2>/dev/null && mv -f cfg_unix/tmux /usr/local/bin 2>/dev/null
fi
rpm -qa | grep ncurses-devel >/dev/null || yum -y install ncurses-devel
rpm -qa | grep perl-Curses >/dev/null || yum -y install perl-Curses
rpm -qa | grep perl-CPAN >/dev/null || yum -y install perl-CPAN
rpm -qa | grep flash-plugin >/dev/null || yum -y install flash-plugin && yum -y update flash-plugin
# install fbterm
rpm -qa | grep libx86-devel >/dev/null || yum -y install libx86-devel
[ ! -e /usr/local/bin/fbterm ] || cp -fp fbterm /usr/local/bin/ 2>/dev/null && chmod +x /usr/local/bin/fbterm 2>/dev/null
# install misc-software
rpm -qa | grep tree >/dev/null || yum -y install tree
rpm -qa | grep sl\\. >/dev/null || yum -y install sl
rpm -qa | grep banner >/dev/null || yum -y install banner
rpm -qa | grep cowsay >/dev/null || yum -y install cowsay
rpm -qa | grep aalib >/dev/null || yum -y install aalib
rpm -qa | grep cmatrix >/dev/null || rpm -ivh http://ftp.linux.cz/pub/linux/opensuse/repositories/home:/zhonghuaren/Fedora_21/x86_64/cmatrix-1.2a-319.1.x86_64.rpm
rpm -qa | grep aria2 >/dev/null || yum -y install aria2
rpm -qa | grep inxi >/dev/null || yum -y install inxi
rpm -qa | grep htop >/dev/null || yum -y install htop
rpm -qa | grep iotop >/dev/null || yum -y install iotop
rpm -qa | grep iftop >/dev/null || yum -y install iftop
rpm -qa | grep iptraf >/dev/null || yum -y install iptraf
rpm -qa | grep rar\\. >/dev/null || yum -y install rar
rpm -qa | grep p7zip >/dev/null || yum -y install p7zip
rpm -qa | grep w3m >/dev/null || yum -y install w3m
#rpm -qa | grep elinks >/dev/null || yum -y install elinks
[ ! -e /usr/local/bin/elinks ] || cp -fp elinks /usr/local/bin/ 2>/dev/null
[ ! -e ~/.elinks ] || mkdir ~/.elinks 2>/dev/null
if [ ! -e ~/.elinks/elinks.conf ]; then
    echo 'set document.codepage.assume="UTF-8"' >~/.elinks/elinks.conf
    echo 'set terminal.linux.charset="UTF-8"' >>~/.elinks/elinks.conf
    echo 'set terminal.xterm.charset="UTF-8"' >>~/.elinks/elinks.conf
    echo 'ui.language="System"' >>~/.elinks/elinks.conf
fi
# install asciiquarium
if [ ! -e /usr/local/bin/asciiquarium ]; then
    echo -e '\n\e[32mInstall asciiquarium\e[m';sleep 1
    sleep 1
    wget http://search.cpan.org/CPAN/authors/id/K/KB/KBAUCOM/Term-Animation-2.6.tar.gz
    [ -e Term-Animation-2.6.tar.gz ] && tar -xf Term-Animation-2.6.tar.gz && cd Term-Animation-2.6/ && perl Makefile.PL >/dev/null && make >/dev/null && make install >/dev/null
    wget http://www.robobunny.com/projects/asciiquarium/asciiquarium.tar.gz
    if [ -e asciiquarium.tar.gz ]; then
        aquaname=`tar tf asciiquarium.tar.gz | cut -d "/" -f 1 | head -1`
        tar -xf asciiquarium.tar.gz
        cp -fp ./${aquaname}/asciiquarium /usr/local/bin 2>/dev/null && chmod +x /usr/local/bin/asciiquarium 2>/dev/null
        chmod 0755 /usr/local/bin/asciiquarium
    fi
    cd ..
    rm -fr Term-Animation* 2>/dev/null
fi

echo -e "\n------ done! ------\n"
}


function sysconf_ubuntu {
clear
echo "Sorry, We Don't support it yet";sleep 2;return
add-apt-repository ppa:tualatrix/ppa -y
add-apt-repository ppa:iaz/battery-status
add-apt-repository ppa:caffeine-developers/ppa
add-apt-repository ppa:shutter/ppa
add-apt-repository ppa:freyja-dev/unity-tweak-tool-daily
add-apt-repository ppa:gnome-terminator
add-apt-repository ppa:ricotz/docky
add-apt-repository ppa:docky-core/ppa
apt-get install battery-status
apt-get install caffeine
apt-get install gnome-do -y
apt-get install ubuntu-restricted-extras -y
apt-get install indicator-weather -y
apt-get install indicator-multiload -y
apt-get install psensor -y
apt-get install shutter
apt-get install unity-tweak-tool
apt-get install gnome-shell gnome-tweak-tool
apt-get install terminator
apt-get install plank
apt-get install docky
apt-get update
apt-get dist-upgrade -y
apt-get upgrade -y
}


option=''
function menu {
    clear
    echo ---------------- You need these files to feel good ------------------
    echo   vim vimtutor .vimrc zsh .zshrc .bashrc tmux .tmux.conf Consolas.ttf
    echo ---------------------------------------------------------------------
    echo
    echo -e "\tSystem Configure Menu, by Zhanglei\n"
    echo -e "\ta. CentOS configure\n"
    echo -e "\tb. Ubuntu configure\n"
    echo -e "\tq. quit!\n"
    echo -en "\tEnter option: "
    read -n 1 option
    case $option in
    [aA])
        cat /proc/version | grep 'Red Hat' >/dev/null || (echo 'Your System seems not like RedHat/CentOS!'; break)
        sysconf_centos
        return;;
    [bB])
        cat /proc/version | grep Ubuntu >/dev/null || (echo 'Your System seems not like Ubuntu!'; break)
        sysconf_ubuntu
        return;;
    [qQ])
        clear; exit;;
    *)
        echo -e "\n\n\t-- SORRY, WRONG OPTION! --"
        sleep 1.5
        clear
    esac
    menu
}
menu


