#!/bin/bash
echo "ubuntu:${default_user_password}" | chpasswd

# Update and install Python 3
apt update -y
apt install -y python3

# Create a basic Python HTTP server script
cat <<EOF > /home/ubuntu/path_server.py
from http.server import BaseHTTPRequestHandler, HTTPServer

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(self.path.encode('utf-8'))

server = HTTPServer(('0.0.0.0', 80), RequestHandler)
print("Starting server on port 80...")
server.serve_forever()
EOF

# Run the script in the background as ubuntu user
chmod +x /home/ubuntu/path_server.py
nohup python3 /home/ubuntu/path_server.py > /home/ubuntu/server.log 2>&1 &
