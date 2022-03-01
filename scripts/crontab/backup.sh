#!/bin/bash
echo "0 5 * * *  /home/untserver/untserver backup > /dev/null 2>&1" >> crontab.txt

echo "[INFO] Activated automatic backup at 5AM"
