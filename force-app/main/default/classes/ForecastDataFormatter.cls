/**
 * Utility class for formatting forecast data for display
 */
public with sharing class ForecastDataFormatter {
  /**
   * Formats forecast data for chart visualization
   * @param accountId The Account ID
   * @return List of formatted forecast data
   */
  @AuraEnabled
  public static List<Map<String, Object>> formatForecastDataForChart(
    Id accountId
  ) {
    List<Forecast__c> forecasts = ForecastingService.getForecastData(accountId);
    List<Map<String, Object>> chartData = new List<Map<String, Object>>();

    for (Forecast__c forecast : forecasts) {
      Map<String, Object> dataPoint = new Map<String, Object>();
      dataPoint.put('period', forecast.Period__c);
      dataPoint.put('amount', forecast.Amount__c);
      dataPoint.put('date', forecast.ForecastDate__c);
      dataPoint.put('type', forecast.ForecastType__c);
      chartData.add(dataPoint);
    }

    return chartData;
  }

  /**
   * Gets the latest forecast amount for an account
   * @param accountId The Account ID
   * @return Latest forecast amount
   */
  @AuraEnabled
  public static Decimal getLatestForecastAmount(Id accountId) {
    List<Forecast__c> forecasts = [
      SELECT Amount__c
      FROM Forecast__c
      WHERE AccountId__c = :accountId
      ORDER BY ForecastDate__c DESC
      LIMIT 1
    ];

    if (forecasts.size() > 0) {
      return forecasts[0].Amount__c;
    }

    return 0;
  }
}
