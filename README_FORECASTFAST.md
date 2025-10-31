FORECASTFAST Quickstart

This repository contains a safe, testable scaffold for a new forecasting app called FORECASTFAST.

Deploy to your org (defaults to `vasanthapersonal`):

```bash
bash ./scripts/deploy-forecastfast.sh vasanthapersonal
```

Run verification including Apex tests:

```bash
bash ./scripts/test-deployment.sh vasanthapersonal
```

Core files:
- `force-app/main/default/classes/ForecastFastService.cls` — moving-average algorithm (no SOQL).
- `force-app/main/default/classes/ForecastFastController.cls` — demo method and `computeForecastForAccount` (SOQL aggregation).
- `force-app/main/default/classes/ForecastFastServiceTest.cls` — unit tests that insert Account/Opportunity sample data.
- `force-app/main/default/lwc/forecastfastApp/` — LWC UI for demo forecasts.

Notes:
- Prettier formatting was applied to multiple files in the repo. Run `npm run prettier` before committing further changes.
- If ESLint errors appear locally referencing package exports, align your Node/npm version to a supported release (Node 18 or 20 recommended) or run lint in a compatible environment.

If you want me to wire FORECASTFAST to product-level aggregation (OpportunityLineItem) or add CI pipeline steps, tell me which target to implement next.
