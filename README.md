# 一键系统DD脚本

仅限KVM架构VPS使用！

## 使用方法

```shell
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontents.com/taffychan/dd/main/InstallNET.sh') \
-d 11 \
-v 64 \
-a -firmware \
-p "自定义root密码" \
-port "自定义ssh端口"
```

> -d 11表示dd的系统为 Debian 11，如果要更换Ubuntu系统，把参数-d 11改为-u 20.04即表示dd的系统为 Ubuntu 20.04

支持DD的系统有：

Debian (-d): 7, 8, 9, 10, 11, 12

Ubuntu (-u): 14.04, 16.04, 18.04, 20.04

CentOS (-c): 6.10
