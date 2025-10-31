public with sharing class ForecastFastController {
  @AuraEnabled(cacheable=true)
  public static Map<String, Decimal> computeDemoForecast() {
    // Demo historical data (oldest -> most recent)
    List<Decimal> historical = new List<Decimal>{
      1200,
      1300,
      1250,
      1400,
      1500
    };
    // Use the current month as the anchor for forecasting
    Date startMonth = Date.newInstance(
      System.today().year(),
      System.today().month(),
      1
    );
    // 3-month window, 6-month horizon
    return ForecastFastService.computeMovingAverageForecast(
      historical,
      3,
      6,
      startMonth
    );
  }

  /**
   * Build a historical monthly series for a given AccountId from closed-won Opportunities
   * and compute a moving-average forecast. This method contains focused SOQL and is
   * covered by tests that create the minimal required data.
   *
   * @param accountId the Account to aggregate
   * @param monthsBack how many months of history to include (default 12 if null/0)
   * @param window moving average window size
   * @param horizon months to forecast ahead
   */
  @AuraEnabled
  public static Map<String, Decimal> computeForecastForAccount(
    Id accountId,
    Integer monthsBack,
    Integer window,
    Integer horizon
  ) {
    Map<String, Decimal> emptyMap = new Map<String, Decimal>();
    if (accountId == null)
      return emptyMap;
    if (monthsBack == null || monthsBack <= 0)
      monthsBack = 12;
    if (window == null || window <= 0)
      window = 3;
    if (horizon == null || horizon <= 0)
      horizon = 6;

    // Start date is the first day of the current month minus (monthsBack - 1)
    Date firstOfThisMonth = Date.newInstance(
      System.today().year(),
      System.today().month(),
      1
    );
    Date startDate = firstOfThisMonth.addMonths(-(monthsBack - 1));

    // Aggregate closed-won Opportunity Amounts by year/month for the account
    List<AggregateResult> grouped = [
      SELECT
        SUM(Amount) total,
        CALENDAR_YEAR(CloseDate) yr,
        CALENDAR_MONTH(CloseDate) m
      FROM Opportunity
      WHERE
        AccountId = :accountId
        AND IsClosed = TRUE
        AND IsWon = TRUE
        AND CloseDate >= :startDate
      GROUP BY CALENDAR_YEAR(CloseDate), CALENDAR_MONTH(CloseDate)
      ORDER BY CALENDAR_YEAR(CloseDate), CALENDAR_MONTH(CloseDate)
    ];

    if (grouped.isEmpty())
      return emptyMap;

    // Build ordered historical series (oldest -> most recent)
    List<Decimal> historical = new List<Decimal>();
    Integer latestYear = null;
    Integer latestMonth = null;
    for (AggregateResult ar : grouped) {
      Decimal total = (Decimal) ar.get('total');
      if (total == null)
        total = 0;
      historical.add(total.setScale(2));
      latestYear = (Integer) ar.get('yr');
      latestMonth = (Integer) ar.get('m');
    }

    if (latestYear == null || latestMonth == null)
      return emptyMap;
    Date anchor = Date.newInstance(latestYear, latestMonth, 1);

    return ForecastFastService.computeMovingAverageForecast(
      historical,
      window,
      horizon,
      anchor
    );
  }
}
