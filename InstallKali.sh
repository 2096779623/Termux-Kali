#/data/data/com.termux/files/usr/bin/bash



folder="kali-fs"
tarball="kali-rootfs.tar.xz"
if [ "$skip" != 1 ]; then
	if [ ! -f $tarball ]; then
		echo -e "\e[32m[*] \e[34m检测架构..."
		case $(dpkg --print-architecture) in
		aarch64)
			archurl="arm64" ;;
		arm)
			archurl="armhf" ;;
		amd64)
			archurl="amd64" ;;
		x86_64)
			archurl="amd64" ;;	
		i*86)
			archurl="i386" ;;
		x86)
			archurl="i386" ;;
		*)
			echo; echo -e "\e[91m未知架构！"; echo; exit 1 ;;
		esac
		echo -e "\e[32m[*] \e[34m下载${archurl}架构的Rootfs..."
		wget "https://raw.fastgit.org/EXALAB/AnLinux-Resources/master/Rootfs/Kali/${archurl}/kali-rootfs-${archurl}.tar.xz" -O $tarball -q
	fi
	cur=$(pwd)
	mkdir -p "$folder"
	cd "$folder"
	echo -e "\e[32m[*] \e[34m解压Rootfs..."
	proot --link2symlink tar -xf ${cur}/${tarball} || (echo -e "\e[91m未能解压Rootfs!"; echo; exit 1)
	cd "$cur"
fi
mkdir -p kali-binds
bin="start-kali.sh"
echo -e "\e[32m[*] \e[34m创建启动脚本..."
cat > $bin <<- EOM
#/data/data/com.termux/files/usr/bin/bash

cd \$(dirname \$0)
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r $folder"
if [ -n "\$(ls -A kali-binds)" ]; then
    for f in kali-binds/* ;do
      . \$f
    done
fi
command+=" -b /dev"
command+=" -b /proc"
command+=" -b kali-fs/tmp:/dev/shm"
## uncomment the following line to have access to the home directory of termux
#command+=" -b /data/data/com.termux/files/home:/root"
## uncomment the following line to mount /sdcard directly to / 
command+=" -b /sdcard"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" TZ=Asia/Shanghai"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM
echo -e "\e[32m[*] \e[34m配置Shebang..."
termux-fix-shebang $bin
echo -e "\e[32m[*] \e[34m设置可执行目录权限..."
chmod +x $bin
echo -e "\e[32m[*] \e[34m删除下载的rootfs镜像..."
rm -rf $tarball
echo
echo -e "\e[32mKali Linux安装成功!\e[39m"
echo -e "\e[32m你可以使用./${bin} 启动Kali Linux！.\e[39m"
