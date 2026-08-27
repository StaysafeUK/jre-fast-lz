#!/usr/bin/env bash

# Helper script to directly inject missing Service Usage roles for Stage 1 service accounts

python3 -c '
import os

paths = [
    "../0-org-setup/datasets/classic/projects/core/iac-0.yaml",
    "fast/stages/0-org-setup/datasets/classic/projects/core/iac-0.yaml"
]

path = None
for p in paths:
    if os.path.exists(p):
        path = p
        break

if not path:
    print("ERROR: iac-0.yaml could not be found.")
    exit(1)

with open(path, "r") as f:
    content = f.read()

target = "  $iam_principals:service_accounts/iac-0/iac-security-ro:\n    - roles/serviceusage.serviceUsageConsumer"
replacement = target + "\n  $iam_principals:service_accounts/iac-0/iac-vpcsc-rw:\n    - roles/serviceusage.serviceUsageConsumer\n  $iam_principals:service_accounts/iac-0/iac-vpcsc-ro:\n    - roles/serviceusage.serviceUsageConsumer"

if target in content and "iac-vpcsc-rw" not in content:
    content = content.replace(target, replacement)
    with open(path, "w") as f:
        f.write(content)
    print("SUCCESS: iac-0.yaml has been updated directly at:", path)
else:
    print("WARNING: iac-0.yaml was already updated, or the target pattern was not found.")
'
