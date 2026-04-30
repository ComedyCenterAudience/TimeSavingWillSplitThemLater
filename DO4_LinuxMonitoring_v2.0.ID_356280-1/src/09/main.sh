#!/bin/bash

set -e

# Check root
if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run as root (sudo ./main.sh)"
    exit 1
fi

# No parameters allowed
if [ $# -ne 0 ]; then
    echo "Error: This script takes no parameters."
    echo "Usage: sudo ./main.sh"
    exit 1
fi

echo "=== Setting up nginx and Prometheus metrics ==="

# Install nginx if missing
if ! command -v nginx &> /dev/null; then
    apt update
    apt install nginx -y
fi

# Create directory and empty metrics file
METRICS_DIR="/var/www/html/prometheus"
METRICS_FILE="$METRICS_DIR/metrics"
mkdir -p "$METRICS_DIR"
touch "$METRICS_FILE"
chmod 644 "$METRICS_FILE"

# Configure nginx to serve /metrics
NGINX_CONF="/etc/nginx/sites-available/default"
if ! grep -q "location /metrics" "$NGINX_CONF"; then
    cp "$NGINX_CONF" "${NGINX_CONF}.bak"
    cat >> "$NGINX_CONF" << 'EOF'

# Prometheus metrics endpoint
location /metrics {
    alias /var/www/html/prometheus/metrics;
    default_type text/plain;
}
EOF
    systemctl restart nginx
    echo "nginx configured"
else
    echo "nginx already has /metrics location"
fi

# Copy helper scripts to /usr/local/bin
cp metricsCom.sh /usr/local/bin/
cp MetLoop.sh /usr/local/bin/
chmod +x /usr/local/bin/metricsCom.sh
chmod +x /usr/local/bin/MetLoop.sh

# Stop any existing instance
pkill -f MetLoop.sh 2>/dev/null || true

# Start the updater in background
nohup /usr/local/bin/MetLoop.sh > /var/log/MetLoop.log 2>&1 &
echo "Metrics updater started (PID: $!)"

# Configure Prometheus to scrape this endpoint
PROM_CFG="/etc/prometheus/prometheus.yml"
if [ -f "$PROM_CFG" ]; then
    cp "$PROM_CFG" "${PROM_CFG}.bak.$(date +%s)"
    if ! grep -q "job_name: 'custom_metrics'" "$PROM_CFG"; then
        sed -i '/scrape_configs:/a\
  - job_name: "custom_metrics"\
    static_configs:\
      - targets: ["localhost:80"]\
    metrics_path: "/metrics"' "$PROM_CFG"
        systemctl restart prometheus
        echo "Prometheus reconfigured"
    else
        echo "Prometheus already has custom_metrics job"
    fi
else
    echo "Warning: Prometheus config not found - skipping"
fi

echo ""
echo "---"
echo "curl http://localhost:9100/metrics"
echo ""
echo "sudo pkill -f MetLoop.sh"