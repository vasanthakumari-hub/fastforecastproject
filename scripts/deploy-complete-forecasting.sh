#!/bin/bash

# Complete deployment script for the Sales Cloud Forecasting App

echo "Starting complete deployment of Sales Cloud Forecasting App..."

# Deploy all Apex classes
echo "Deploying Apex classes..."
sf project deploy start --target-org vasanthapersonal --source-dir force-app/main/default/classes/

# Deploy LWC components
echo "Deploying LWC components..."
sf project deploy start --target-org vasanthapersonal --source-dir force-app/main/default/lwc/

# Deploy custom objects and fields
echo "Deploying custom objects..."
sf project deploy start --target-org vasanthapersonal --source-dir force-app/main/default/objects/

# Deploy layouts
echo "Deploying layouts..."
sf project deploy start --target-org vasanthapersonal --source-dir force-app/main/default/layouts/

# Deploy permission sets
echo "Deploying permission sets..."
sf project deploy start --target-org vasanthapersonal --source-dir force-app/main/default/permissionsets/

# Deploy applications
echo "Deploying applications..."
sf project deploy start --target-org vasanthapersonal --source-dir force-app/main/default/applications/

echo "Complete deployment finished!"
