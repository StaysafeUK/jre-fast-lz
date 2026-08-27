#!/usr/bin/env bash

# This script manually assigns the serviceusage.serviceUsageConsumer role to
# all stage service accounts to prevent 403 Permission Denied errors on
# GCS state backend access during 'terraform init'.

PROJECT_ID="placard-prod-iac-core-0"

echo "Force-setting active gcloud project to: ${PROJECT_ID}..."
gcloud config set project "${PROJECT_ID}"

# Export environment variables for the current session to override any old session caches
export GOOGLE_PROJECT="${PROJECT_ID}"
export GOOGLE_CLOUD_PROJECT="${PROJECT_ID}"

echo "Adding serviceusage consumer role on project: ${PROJECT_ID}..."

# Stage 2 - Networking
echo "Applying Stage 2 - Networking..."
gcloud projects add-iam-policy-binding "${PROJECT_ID}" --member="serviceAccount:iac-networking-rw@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/serviceusage.serviceUsageConsumer"
gcloud projects add-iam-policy-binding "${PROJECT_ID}" --member="serviceAccount:iac-networking-ro@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/serviceusage.serviceUsageConsumer"

# Stage 2 - Security
echo "Applying Stage 2 - Security..."
gcloud projects add-iam-policy-binding "${PROJECT_ID}" --member="serviceAccount:iac-security-rw@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/serviceusage.serviceUsageConsumer"
gcloud projects add-iam-policy-binding "${PROJECT_ID}" --member="serviceAccount:iac-security-ro@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/serviceusage.serviceUsageConsumer"

# Stage 2 - Project Factory
echo "Applying Stage 2 - Project Factory..."
gcloud projects add-iam-policy-binding "${PROJECT_ID}" --member="serviceAccount:iac-pf-rw@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/serviceusage.serviceUsageConsumer"
gcloud projects add-iam-policy-binding "${PROJECT_ID}" --member="serviceAccount:iac-pf-ro@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/serviceusage.serviceUsageConsumer"

# Stage 1 - VPC Service Controls
echo "Applying Stage 1 - VPC Service Controls..."
gcloud projects add-iam-policy-binding "${PROJECT_ID}" --member="serviceAccount:iac-vpcsc-rw@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/serviceusage.serviceUsageConsumer"
gcloud projects add-iam-policy-binding "${PROJECT_ID}" --member="serviceAccount:iac-vpcsc-ro@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/serviceusage.serviceUsageConsumer"

echo "Done! All serviceusage consumer roles successfully applied."
