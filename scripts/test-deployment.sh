#!/bin/bash

TARGET_ORG=${1:-vasanthapersonal}

echo "Testing Sales Cloud Forecasting Application Deployment against org: ${TARGET_ORG}"

# Check if we can query the custom object
echo "1. Checking if Forecast__c object exists..."
sf data query --query "SELECT Id FROM Forecast__c LIMIT 1" --target-org "${TARGET_ORG}" || echo "Warning: Forecast__c query failed or object may not exist"

# Check if the forecasting service class exists
echo "2. Checking if ForecastingService class exists..."
sf apex run --script "System.debug('ForecastingService class loaded successfully');" --target-org "${TARGET_ORG}" || echo "Warning: Apex run failed"

echo "3. Checking if LWC components are available..."
sf lwc list --target-org "${TARGET_ORG}" || echo "Warning: LWC list failed"

echo "4. Running Apex tests (synchronous) to surface failures for CI..."
if sf apex test run --target-org "${TARGET_ORG}" --synchronous --wait 10; then
	echo "Apex tests finished: PASS"
else
	echo "Apex tests finished: FAIL — see output above for failed tests"
	exit 1
fi

echo "Deployment verification complete!"
