#!/bin/bash

# Update package lists
sudo apt-get update

# Install Nginx
sudo apt-get install -y nginx 

# Install required packages for retrieving instance metadata
sudo apt-get install -y curl jq vim

# Get instance metadata
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
&& curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/    

INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
IP_ADDRESS=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)
MAC_ADDRESS=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/mac)

# Write HTML content to display instance information
cat <<EOF | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instance Information</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h1 {
            color: #333;
        }
        table {
            border-collapse: collapse;
            width: 50%;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>Instance Information</h1>
    <table>
        <tr>
            <th>Attribute</th>
            <th>Value</th>
        </tr>
        <tr>
            <td>Instance ID</td>
            <td>$INSTANCE_ID</td>
        </tr>
        <tr>
            <td>IP Address</td>
            <td>$IP_ADDRESS</td>
        </tr>
        <tr>
            <td>MAC Address</td>
            <td>$MAC_ADDRESS</td>
        </tr>
    </table>
</body>
</html>
EOF

# Restart Nginx server to apply changes
sudo systemctl restart nginx

