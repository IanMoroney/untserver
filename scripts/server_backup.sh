#!/bin/bash
echo "[INFO] Starting backup, this backup will create a complete tar bzip2 archive of the whole server"

sleep 3s

./untserver backup

sleep 3s

echo "[INFO] Backup complete"
