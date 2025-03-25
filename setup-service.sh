#!/bin/bash

# Build the application for production
echo "Building the Next.js application..."
pnpm build

# Copy the service file to the systemd directory
echo "Installing systemd service..."
sudo cp hackernews-cn.service /etc/systemd/system/

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable hackernews-cn.service

# Start the service
sudo systemctl start hackernews-cn.service

# Check status
echo "Service status:"
sudo systemctl status hackernews-cn.service

echo ""
echo "Service installed and started!"
echo "You can manage it with these commands:"
echo "  sudo systemctl start hackernews-cn.service    # Start the service"
echo "  sudo systemctl stop hackernews-cn.service     # Stop the service"
echo "  sudo systemctl restart hackernews-cn.service  # Restart the service"
echo "  sudo systemctl status hackernews-cn.service   # Check status"
echo "  sudo journalctl -u hackernews-cn.service      # View logs" 