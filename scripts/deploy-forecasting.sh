#!/bin/bash

# Script to deploy the Sales Cloud Forecasting App

echo "Deploying Sales Cloud Forecasting App..."

# Deploy the metadata to Salesforce
sf deploy metadata --source-dir force-app/main/default --target-org vasanthapersonal

echo "Deployment complete!"
echo "Please navigate to your Salesforce org to verify the deployment."
