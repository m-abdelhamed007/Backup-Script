# Backup-Script
Step 2: Create the Backup Script
Create the Script File: Open a text editor and create a new script file and chmod file:
```bash
touch backup.sh
vim backup.sh
chmod +x backup.sh
```
to test check and verfiy backup dir and backup.log 
Cron Job Setup
To schedule the script to run daily, you can add a cron job. Open the crontab for editing:
```bash
sudo crontab -e
```
then add 
```bash
0 2 * * * /root/backup.sh
```
How to configure paths and retention
```bash

SOURCE_DIR="/var/www"
BACKUP_DIR="$HOME/backup"
RETENTION_DAYS=7
LOG_FILE="$HOME/backup.log"
LOG_RETENTION=5
EMAIL="admin@example.com"
```
How to test the failure alert
change and dir for backup or  source dir  to non exist dir and check mail or backup.log
