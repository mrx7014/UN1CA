#!/bin/bash

# Check if a file argument is provided
if [[ "$#" -lt 1 ]]; then
    echo "ERROR: No file specified!"
    exit 1
fi

# Store the file path
FILE="$1"

# Check if the specified file exists
if [[ ! -f "$FILE" ]]; then
    echo "ERROR: File does not exist or is not readable: $FILE"
    exit 1
fi

# Query GoFile API to get the best server for upload
SERVER=$(curl -s https://api.gofile.io/servers | jq -r '.data.servers[0].name')

# Verify if the server name is retrieved successfully
if [[ -z "$SERVER" ]]; then
    echo "ERROR: Unable to retrieve GoFile server."
    exit 1
fi

# Upload the file to GoFile and retrieve the download link
UPLOAD_RESPONSE=$(curl -s -F "file=@$FILE" "https://${SERVER}.gofile.io/uploadFile")
LINK=$(echo "$UPLOAD_RESPONSE" | jq -r '.data.downloadPage')

# Check if the link is valid
if [[ -z "$LINK" || "$LINK" == "null" ]]; then
    echo "ERROR: File upload failed."
    echo "Response: $UPLOAD_RESPONSE"
    exit 1
fi

# Output the link for use in GitHub Actions
echo "::set-output name=download_link::$LINK"
