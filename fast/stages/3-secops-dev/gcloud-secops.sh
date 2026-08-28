#!/usr/bin/env bash

# Pure-bash safe script to locate and link existing Stage 0 variable and provider outputs for Stage 3 SecOps

echo "Locating Stage 0 variables..."

# Find the full path to the Stage 0 output json
FULL_PATH=$(find ~ -name "0-org-setup.auto.tfvars.json" 2>/dev/null | head -n 1)

if [ -z "$FULL_PATH" ]; then
  echo "ERROR: Stage 0 outputs (0-org-setup.auto.tfvars.json) could not be found anywhere under your home directory."
  echo "Please verify if Stage 0 has been applied successfully."
  exit 1
fi

# Extract directories cleanly without complex find -exec syntax
FOUND_DIR=$(dirname "$FULL_PATH")
PARENT_DIR=$(dirname "$FOUND_DIR")

echo "Success: Found Stage 0 outputs at: $PARENT_DIR"

# Clean up existing symlinks
echo "Cleaning existing links in fast/stages/3-secops-dev..."
rm -f *.tfvars *.json *providers.tf

# Link providers
if [ -f "$PARENT_DIR/providers/3-secops-dev-providers.tf" ]; then
  ln -s "$PARENT_DIR/providers/3-secops-dev-providers.tf" ./
  echo "✔ Linked 3-secops-dev-providers.tf"
else
  echo "⚠ Warning: 3-secops-dev-providers.tf was not found under $PARENT_DIR/providers/"
fi

# Link variable JSONs
if [ -f "$FOUND_DIR/0-globals.auto.tfvars.json" ]; then
  ln -s "$FOUND_DIR/0-globals.auto.tfvars.json" ./
  echo "✔ Linked 0-globals.auto.tfvars.json"
fi

if [ -f "$FOUND_DIR/0-org-setup.auto.tfvars.json" ]; then
  ln -s "$FOUND_DIR/0-org-setup.auto.tfvars.json" ./
  echo "✔ Linked 0-org-setup.auto.tfvars.json"
fi

echo "Done! Stage 3 SecOps links successfully created."
