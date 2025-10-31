/**
 * Controller class for handling forecasting actions
 */
public with sharing class ForecastController {
  /**
   * Calculates monthly forecasts (Trend = Linear Regression fallback to MA) for the next N months
   * and upserts Forecast__c rows for the Account.
   */
  @AuraEnabled
  public static Map<String, Object> calculateAndSaveForecast(Id accountId) {
    Map<String, Object> result = new Map<String, Object>();
    try {
      Integer monthsBack = 12;
      Integer horizon = 6;
      // Trend forecast based on LR with fallback to MA
      Map<String, Decimal> trend = ForecastingService.computeLinearRegressionForecast(
        accountId,
        null,
        monthsBack,
        horizon
      );
      if (trend.isEmpty()) {
        trend = ForecastingService.computeMovingAverageForecast(
          accountId,
          null,
          3,
          horizon
        );
      }
      // Upsert as 'Trend'
      ForecastingService.upsertMonthlyForecasts(accountId, trend, 'Trend');

      // Optionally compute baseline from open pipeline and store as 'Baseline'
      Map<String, Decimal> baseline = ForecastingService.getPipelineBaselineByMonth(
        accountId,
        null,
        horizon
      );
      if (!baseline.isEmpty()) {
        ForecastingService.upsertMonthlyForecasts(
          accountId,
          baseline,
          'Baseline'
        );
      }

      // Build a small summary: next month trend amount
      Date nextMonth = Date.newInstance(
          Date.today().year(),
          Date.today().month(),
          1
        )
        .addMonths(1);
      Integer nextMonthNum = nextMonth.month();
      String nextMonthStr = String.valueOf(nextMonthNum);
      if (nextMonthNum < 10) {
        nextMonthStr = '0' + nextMonthStr;
      }
      String nextKey = String.valueOf(nextMonth.year()) + '-' + nextMonthStr;
      Decimal forecastAmount = trend.containsKey(nextKey)
        ? trend.get(nextKey)
        : (trend.isEmpty() ? 0 : trend.values()[0]);

      result.put('success', true);
      result.put(
        'message',
        'Monthly forecasts calculated (Trend and Baseline) and saved successfully'
      );
      result.put('forecastAmount', forecastAmount);
    } catch (Exception e) {
      result.put('success', false);
      result.put('message', 'Error calculating forecast: ' + e.getMessage());
      result.put('forecastAmount', 0);
    }
    return result;
  }

  @AuraEnabled
  public static List<Forecast__c> getAccountForecasts(Id accountId) {
    return [
      SELECT
        Id,
        Period__c,
        Amount__c,
        ForecastDate__c,
        ForecastType__c,
        AccountId__c,
        AccountId__r.Name
      FROM Forecast__c
      WHERE AccountId__c = :accountId
      ORDER BY ForecastDate__c
    ];
  }

  @AuraEnabled
  public static List<Forecast__c> getAllForecasts() {
    return [
      SELECT
        Id,
        Period__c,
        Amount__c,
        ForecastDate__c,
        ForecastType__c,
        AccountId__c,
        AccountId__r.Name
      FROM Forecast__c
      ORDER BY ForecastDate__c
    ];
  }
}
