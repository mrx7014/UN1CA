#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if a file argument is provided
if [[ "$#" -lt 1 ]]; then
    echo "ERROR: No file specified!"
    exit 1
fi

# Store the file path (preserving spaces)
FILE="$1"

# Check if the specified file exists and is readable
if [[ ! -f "$FILE" ]]; then
    echo "ERROR: File does not exist or is not readable: $FILE"
    exit 1
fi

# Query GoFile API to find the best server for upload
SERVER=$(curl -s https://api.gofile.io/servers | jq -r '.data.servers[0].name')

# Verify if server name is successfully retrieved
if [[ -z "$SERVER" ]]; then
    echo "ERROR: Unable to retrieve GoFile server."
    exit 1
fi

# Upload the file to GoFile and retrieve the download page URL
UPLOAD_RESPONSE=$(curl -s -F "file=@$FILE" "https://${SERVER}.gofile.io/uploadFile")

# Extract the download page link using jq
LINK=$(echo "$UPLOAD_RESPONSE" | jq -r '.data.downloadPage')

# Check if the upload succeeded
if [[ -z "$LINK" || "$LINK" == "null" ]]; then
    echo "ERROR: File upload failed."
    echo "Response: $UPLOAD_RESPONSE"
    exit 1
fi

# Display the download link
echo "File uploaded successfully!"
echo "Download Link: $LINK"
