## FORECASTFAST — Quick AI agent guide

Read these files first to understand the app and what you can safely edit:
- `force-app/main/default/classes/ForecastFastService.cls` (core, no SOQL)
- `force-app/main/default/classes/ForecastFastController.cls` (demo + focused SOQL aggregation)
- `force-app/main/default/classes/ForecastFastServiceTest.cls` (Apex tests that create minimal test data)
- `force-app/main/default/lwc/forecastfastApp/` (LWC UI)

Commands you will use (repo root):
- Format everything: `npm run prettier` (Prettier + Apex plugin)
- Run LWC unit tests: `npm test` (may exit non-zero if there are no JS tests)
- Deploy FORECASTFAST: `bash ./scripts/deploy-forecastfast.sh vasanthapersonal`
- Verify deployment + run Apex tests: `bash ./scripts/test-deployment.sh vasanthapersonal`

Project-specific patterns / gotchas
- Many Apex files in this repo were previously stubbed to avoid SOQL deployment issues; when adding SOQL, add focused unit tests that insert minimal required data (Accounts, Opportunities, OpportunityLineItems) so CI passes.
- XML metadata must be well-formed: escape `&` as `&amp;` in formula fields (we fixed `Expense__c/fields/Name.field-meta.xml`).
- Prefer AggregateResult + GROUP BY year/month for monthly aggregation (see `computeForecastForAccount` in `ForecastFastController.cls`).

When adding logic that touches the database
- Add a targeted Apex test that creates the exact records you need. Example test creates an `Account` and several `Opportunity` records with `StageName='Closed Won'` and calls `computeForecastForAccount`.
- Keep SOQL small and deterministic; prefer indexed fields (AccountId, CloseDate) and LIMIT when appropriate.

If your change requires larger org objects (new fields, pricebooks, products), update the README and include a data-creation Apex script under `scripts/apex/` so CI/scratch orgs can be provisioned deterministically.

Where to look for examples
- Aggregation example: `force-app/main/default/classes/ForecastFastController.cls`
- Formatting hook and checks: `package.json` (prettier, lint-staged, husky)
- Deployment helpers: `scripts/deploy-forecastfast.sh`, `scripts/test-deployment.sh`

If any part of the CI or local tooling fails (ESLint package export errors, missing tests), report the exact terminal output and I'll add a targeted fix (node version guidance, package changes, or CI step modifications).
