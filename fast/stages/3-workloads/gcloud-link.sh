#!/usr/bin/env bash

# Pure-bash safe script to locate and link existing Stage variables for Stage 3 Workload deployments

echo "Locating Stage variables..."

# Find the full path to the Stage 0 output json
FULL_PATH=$(find ~ -name "0-org-setup.auto.tfvars.json" 2>/dev/null | head -n 1)

if [ -z "$FULL_PATH" ]; then
  echo "ERROR: Stage 0 outputs (0-org-setup.auto.tfvars.json) could not be found anywhere under your home directory."
  echo "Please verify if Stage 0 has been applied successfully."
  exit 1
fi

FOUND_DIR=$(dirname "$FULL_PATH")

echo "Success: Found Stage variables at: $FOUND_DIR"

# Clean up existing symlinks
echo "Cleaning existing links in fast/stages/3-workloads..."
rm -f *.tfvars *.json

# Link variable JSONs containing project IDs and subnet self-links
if [ -f "$FOUND_DIR/0-org-setup.auto.tfvars.json" ]; then
  ln -s "$FOUND_DIR/0-org-setup.auto.tfvars.json" ./
  echo "✔ Linked 0-org-setup.auto.tfvars.json"
fi

if [ -f "$FOUND_DIR/2-networking.auto.tfvars.json" ]; then
  ln -s "$FOUND_DIR/2-networking.auto.tfvars.json" ./
  echo "✔ Linked 2-networking.auto.tfvars.json (Networking)"
fi

echo "Done! Stage 3 Workload links successfully created."
