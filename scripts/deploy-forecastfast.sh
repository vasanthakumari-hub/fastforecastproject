#!/bin/bash
# Deploy FORECASTFAST metadata to a target org with retries and verbose output

TARGET_ORG=${1:-vasanthapersonal}
SOURCE_DIR="force-app/main/default"
MAX_RETRIES=3
SLEEP_SECONDS=5

echo "Deploying FORECASTFAST to org: ${TARGET_ORG}"
for attempt in $(seq 1 $MAX_RETRIES); do
    echo "Attempt $attempt/$MAX_RETRIES: sf deploy metadata --source-dir ${SOURCE_DIR} --target-org ${TARGET_ORG}"
    if sf deploy metadata --source-dir "${SOURCE_DIR}" --target-org "${TARGET_ORG}" --wait 10; then
        echo "Deployment succeeded on attempt $attempt"
        exit 0
    else
        echo "Deployment failed on attempt $attempt"
        if [ $attempt -lt $MAX_RETRIES ]; then
            echo "Retrying in ${SLEEP_SECONDS}s..."
            sleep ${SLEEP_SECONDS}
        fi
    fi
done

echo "Deployment failed after ${MAX_RETRIES} attempts. Inspect the output above for errors."
exit 1
