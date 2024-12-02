Lab 3: Create a shell script to ping every server in the 172.16.17.x subnet (where x is a number between 0 and 255). If the ping succeeds, display the message “Server 172.16.17.x is up and running” If the ping fails, display the message “Server 172.16.17.x is unreachable”.
vim ping_servers.sh
add this to ping_servers.sh

#!/bin/bash

# Configuration
for in {0..255}; do
ip-"192.168.1. Si "
echo "Pinging Sip... "
ping -c 1 -W 1 Sip &> /dev/null
if [ S? -eq O ] ; then
echo "Server Sip is up and running"
else
echo "Server Sip is unreachable"
done
# Make script executable
chmod +x ping_servers.sh

# Run the script
./ping_servers.sh
