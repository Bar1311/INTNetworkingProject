#!/bin/bash
#!/bin/bash

# Check if KEY_PATH is set
if [ -z "$KEY_PATH" ]; then
    echo "KEY_PATH env var is expected"
    exit 5
fi

# Check if at least one argument is provided (public instance IP)
if [ "$#" -lt 1 ]; then
    echo "Please provide bastion IP address"
    exit 5
fi

# Assign arguments to variables
PUBLIC_IP="$1"
PRIVATE_IP="$2"
COMMAND="$3"

# Define the default user for the instances (adjust as necessary)
USER="ubuntu"  # Assuming the default user is 'ubuntu'

# If only the public IP is provided, connect to the public instance
if [ -z "$PRIVATE_IP" ]; then
    ssh -i "$KEY_PATH" "$USER@$PUBLIC_IP"
else
    # If both public and private IPs are provided, connect to the private instance via the public instance
    if [ -z "$COMMAND" ]; then
        ssh -i "$KEY_PATH" -A "$USER@$PUBLIC_IP" ssh "$USER@$PRIVATE_IP"
    else
        # If a command is provided, run it on the private instance
        ssh -i "$KEY_PATH" -A "$USER@$PUBLIC_IP" ssh "$USER@$PRIVATE_IP" "$COMMAND"
    fi
fi
