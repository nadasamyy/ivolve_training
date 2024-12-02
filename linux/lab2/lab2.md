# Lab 2: Schedule a script to run daily at 5:00 PM that automates checking disk space usage for the root file system and sends an email(using msm-tp, mailutils) alert if usage exceeds a specified threshold (10%)

## Steps

### 1. Install Required Packages
```bash
sudo apt-get update
sudo apt-get install -y msmtp msmtp-mta mailutils
```

### 2. Configure msmtp
```bash
sudo nano /etc/msmtprc
```
Add the following configuration to `/etc/msmtprc` :
```
# Default settings
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log

# Gmail account
account        gmail
host           smtp.gmail.com
port           587
from           your-email@gmail.com
user           your-email@gmail.com
password       your-app-password

# Set default account
account default : gmail
```
- note: To get an App Password for Gmail, search on youtube
Set proper permissions.
```bash
sudo chmod 600 /etc/msmtprc
```

### 3. Create the Monitoring Script
Create `disk_monitor.sh` & add the following to it:
```bash
#!/bin/bash

# Configuration
THRESHOLD=10
EMAIL_TO="recipient@example.com"
EMAIL_FROM="your-email@gmail.com"
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
DATE=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="/var/log/disk_monitor.log"

# Function to log messages
log_message() {
    echo "[$DATE] $1" >> "$LOG_FILE"
    echo "[$DATE] $1"
}

# Get disk usage percentage
DISK_USAGE=$(df / | grep '/$' | awk '{print $5}' | tr -d '%')

# Get detailed disk information
DISK_INFO=$(df -h / | grep '/$')
TOTAL=$(echo "$DISK_INFO" | awk '{print $2}')
USED=$(echo "$DISK_INFO" | awk '{print $3}')
AVAILABLE=$(echo "$DISK_INFO" | awk '{print $4}')
PERCENT=$(echo "$DISK_INFO" | awk '{print $5}')

# Check if disk usage exceeds threshold
if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
    # Create email content
    EMAIL_CONTENT="Subject: Disk Space Alert - EC2 Instance $INSTANCE_ID
From: $EMAIL_FROM
To: $EMAIL_TO

Warning: Disk space usage has exceeded the threshold!

Instance ID: $INSTANCE_ID
Time: $DATE

Disk Usage Details:
- Total: $TOTAL
- Used: $USED
- Available: $AVAILABLE
- Usage Percentage: $PERCENT

Please take necessary action to prevent system issues."

    # Send email using msmtp
    echo "$EMAIL_CONTENT" | msmtp -t "$EMAIL_TO"

    # Log alert
    log_message "Alert sent - Disk usage at $PERCENT"
else
    # Log normal status
    log_message "Disk usage normal at $PERCENT"
fi
```

### 4. Set Script `disk_monitor.sh` Permissions
```bash
sudo chmod +x /path/to/disk_monitor.sh
sudo chown root:root /path/to/disk_monitor.sh
```

### 5. Create Cron Job
```bash
sudo crontab -e
```
Add this line to run at 5:00 PM daily:
```
0 17 * * * /path/to/disk_monitor.sh
```

## Testing
```bash
sudo ./disk_monitor.sh
```
