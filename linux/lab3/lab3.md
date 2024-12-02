# Ping Servers Script

This script is designed to ping all servers in the `172.16.17.x` subnet and provides status updates for each server. 

## Script Overview

The script performs the following actions:
1. Loops through all IPs in the `172.16.17.x` subnet (`x` ranges from 0 to 255).
2. Pings each server to check connectivity.
3. Displays a message indicating whether the server is **up and running** or **unreachable**.

## How to Use

1. Create a file named `ping_servers.sh`:
    ```bash
    vim ping_servers.sh
    ```

2. Add the following code to the file:
    ```bash
    #!/bin/bash

    # Ping all servers in the 172.16.17.x subnet
    for i in {0..255}; do
        ip="172.16.17.$i"
        echo "Pinging $ip..."
        ping -c 1 -W 1 $ip &> /dev/null
        if [ $? -eq 0 ]; then
            echo "Server $ip is up and running"
        else
            echo "Server $ip is unreachable"
        fi
    done
    ```

3. Save the file and make it executable:
    ```bash
    chmod +x ping_servers.sh
    ```

4. Run the script:
    ```bash
    ./ping_servers.sh
    ```

## Output Example

Below is an example of the script's output:


