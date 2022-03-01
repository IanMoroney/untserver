#!/bin/bash
free=$(df -k --output=avail /home/untserver/.local/share/Unturned/ | tail -n1)   # df -k not df -h
freeGB=$(expr $free / 1024 / 1024)
if [[ $free -lt 12582912 ]]; then               # 12G = 12*1024*1024k
     space=no
fi
