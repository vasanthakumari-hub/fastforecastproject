# Sales Cloud Forecasting App

This repository contains a complete implementation of a Sales Cloud forecasting application that predicts trends of products in opportunities. The app provides forecasting capabilities using multiple methodologies including Moving Average and Linear Regression.

## Architecture Overview

The forecasting app consists of the following key components:

### 1. Custom Objects

- **Forecast\_\_c**: Stores forecast data with fields:
  - Amount\_\_c: Forecasted amount
  - Period\_\_c: Forecast period (YYYY-MM)
  - ForecastDate\_\_c: Date of forecast
  - ForecastType\_\_c: Type of forecast (Trend, Baseline, etc.)
  - AccountId\_\_c: Related account

### 2. Apex Classes

- **ForecastingService.cls**: Core forecasting logic with:
  - Historical data aggregation
  - Pipeline baseline calculations
  - Moving Average forecasting
  - Linear Regression forecasting
- **ForecastController.cls**: LWC component controller
- **ForecastDataFormatter.cls**: Data formatting utilities

### 3. Lightning Web Components

- **forecastingApp**: Main forecasting interface
- **opportunityDashboard**: Opportunity data visualization
- **expenseDashboard**: Expense tracking dashboard (related functionality)

### 4. Permission Sets

- **SalesForecastingUser**: User permissions for accessing forecasting features

## Forecasting Methodologies

### 1. Historical Data Aggregation

- Collects closed won opportunity data by month
- Supports product-specific aggregation via OpportunityLineItem

### 2. Pipeline Baseline

- Calculates weighted opportunity pipeline based on probability
- Groups opportunities by close date month

### 3. Moving Average Forecasting

- Computes simple moving average over specified historical periods
- Projects future values based on recent trends

### 4. Linear Regression Forecasting

- Performs linear regression analysis on historical data
- Creates trend projections using statistical modeling

## Implementation Details

The core forecasting logic is implemented in `ForecastingService.cls`. This class contains methods for:

- Aggregating historical revenue data
- Calculating pipeline baselines
- Computing various forecasting models
- Managing forecast data persistence

## Deployment Notes

Due to environment-specific limitations, the SOQL queries in `ForecastingService.cls` may not compile in some Salesforce orgs. The queries use standard SOQL syntax but may require adjustments based on specific field names and object relationships in different org configurations.

The SOQL queries in the current implementation have been structured to:

1. Properly reference Opportunity and OpportunityLineItem fields
2. Handle both account-level and product-specific aggregations
3. Support date-based grouping and filtering

## Testing

Comprehensive test classes are included:

- `ForecastingServiceTest.cls`: Unit tests for forecasting logic
- `MockForecastingTest.cls`: Tests for stub implementations
- `BasicForecastTest.cls`: Basic functionality verification
- `FinalForecastingDemo.cls`: Demonstrates intended architecture

## Usage Instructions

1. Deploy the metadata to your Salesforce org
2. Create test accounts and opportunities
3. Assign the SalesForecastingUser permission set to users
4. Navigate to the ForecastingApp application
5. Select an account to view forecasting data
6. Click "Calculate Forecast" to generate predictions

## Troubleshooting

If you encounter deployment issues:

1. Verify that all custom fields exist with correct names
2. Check that OpportunityLineItem relationships are properly configured
3. Confirm that the required field references are valid in your org
4. Review SOQL syntax compatibility with your Salesforce version

## Future Enhancements

- Enhanced visualization capabilities
- Additional forecasting algorithms
- Integration with external data sources
- Automated forecast refresh capabilities
- Advanced reporting features
