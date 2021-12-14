# KaliTermux
### 信息
安装Kali Linux在安卓的Termux!

该脚本最初是由<a href="https://github.com/EXALAB">EXALAB</a>到<a href="https://github.com/EXALAB/AnLinux-App">AnLinux</a> project.</br>
此版本的脚本略有修改。</br>
与原版的区别：
- 默认情况下启用将内部存储 (/sdcard) 挂载到根 (/)
- 改进的输出
- 代码中的一些改进
- 中文版
- 时区为上海
### How to use
只需将此代码复制并粘贴到 Termux 命令行即可安装 Kali Linux：<br/>
```pkg install wget proot -y && wget https://raw.fastgit.org/2096779623/Termux-Kali/master/InstallKali.sh && bash InstallKali.sh```

After installing run ```./start-kali.sh``` to launch Kali.
