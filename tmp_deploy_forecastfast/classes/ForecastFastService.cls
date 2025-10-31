public with sharing class ForecastFastService {
  /**
   * Compute a simple moving average forecast.
   * - historical: list of monthly values (oldest -> most recent)
   * - window: lookback window size for moving average
   * - horizon: number of future months to predict
   * - startMonth: a Date representing the month of the most recent historical value (first day of month)
   *
   * Returns a map where key = YYYY-MM and value = forecasted amount (Decimal, 2 decimals)
   */
  public static Map<String, Decimal> computeMovingAverageForecast(
    List<Decimal> historical,
    Integer window,
    Integer horizon,
    Date startMonth
  ) {
    Map<String, Decimal> out = new Map<String, Decimal>();
    if (
      historical == null ||
      historical.size() == 0 ||
      window <= 0 ||
      horizon <= 0 ||
      startMonth == null
    ) {
      return out;
    }

    Integer n = historical.size();
    // Defensive copy so tests calling this method can reuse original list safely
    List<Decimal> series = new List<Decimal>();
    for (Integer i = 0; i < n; i++)
      series.add(historical.get(i));

    Date cursor = startMonth;
    for (Integer h = 1; h <= horizon; h++) {
      // compute average of the last 'window' entries
      Integer startIdx = Math.max(0, series.size() - window);
      Decimal sum = 0;
      Integer cnt = 0;
      for (Integer i = startIdx; i < series.size(); i++) {
        sum += series.get(i);
        cnt++;
      }
      Decimal avg = (cnt == 0) ? 0 : (sum / cnt);
      avg = avg.setScale(2);

      cursor = cursor.addMonths(1);
      String monthKey =
        String.valueOf(cursor.year()) +
        '-' +
        (cursor.month() < 10
          ? '0' + String.valueOf(cursor.month())
          : String.valueOf(cursor.month()));
      out.put(monthKey, avg);

      // slide the window by appending the forecast so subsequent forecasts use it
      series.add(avg);
    }

    return out;
  }
}