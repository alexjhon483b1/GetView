#!/bin/bash

# Check if an argument (IP address) is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi
echo "$1"
# Assign the IP address from the argument to a variable
ip_address="$1"

# Construct the URL with the provided IP address
url="http://${ip_address}"

# Specify the custom headers
headers=(
    "-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8'"
    "-H 'Connection: keep-alive'"
    "-H 'User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:100.0) Gecko/20100101 Firefox/100.0'"
)

# Create a "Capture" directory if it doesn't exist
capture_directory="Capture"
mkdir -p "$capture_directory"

# Use curl with the specified headers and a timeout of 3 seconds to fetch the content from the URL
html_content=$(eval curl -s --max-time 3 "$url" "${headers[@]}")

# Check if curl received any content
if [ -z "$html_content" ]; then
    echo "No content received. Exiting without taking a screenshot."
    exit 1
fi

# Use wkhtmltoimage to convert HTML content to an image, crop to the top 500x1000 pixels, and save in the "Capture" directory
echo "$html_content" | wkhtmltoimage --crop-h 500 --crop-w 1000 - "$capture_directory/${ip_address}.png"

# Optionally, you can add error handling or additional logic as needed

