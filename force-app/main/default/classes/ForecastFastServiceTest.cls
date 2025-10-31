@isTest
private class ForecastFastServiceTest {
  @isTest
  static void testComputeMovingAverageForecast_basic() {
    List<Decimal> hist = new List<Decimal>{ 100, 120, 110, 130 };
    Date startMonth = Date.newInstance(2025, 7, 1);
    Map<String, Decimal> res = ForecastFastService.computeMovingAverageForecast(
      hist,
      2,
      3,
      startMonth
    );
    System.assertEquals(3, res.size(), 'Should return horizon-sized map');
    // Values should be non-null and numeric
    for (String k : res.keySet()) {
      System.assertNotEquals(null, res.get(k));
    }
  }

  @isTest
  static void testComputeForecastForAccount_withData() {
    // Create Account and Opportunities to provide historical closed-won data
    Account a = new Account(Name = 'FF Test Account');
    insert a;

    // Anchor to the first of current month so test is stable over time
    Date anchor = Date.newInstance(
      System.today().year(),
      System.today().month(),
      1
    );

    List<Opportunity> opps = new List<Opportunity>();
    // Create 4 closed-won opportunities in the last 4 months with known amounts
    opps.add(
      new Opportunity(
        Name = 'O1',
        AccountId = a.Id,
        StageName = 'Closed Won',
        CloseDate = anchor.addMonths(-3),
        Amount = 100,
        IsWon = true
      )
    );
    opps.add(
      new Opportunity(
        Name = 'O2',
        AccountId = a.Id,
        StageName = 'Closed Won',
        CloseDate = anchor.addMonths(-2),
        Amount = 200,
        IsWon = true
      )
    );
    opps.add(
      new Opportunity(
        Name = 'O3',
        AccountId = a.Id,
        StageName = 'Closed Won',
        CloseDate = anchor.addMonths(-1),
        Amount = 300,
        IsWon = true
      )
    );
    opps.add(
      new Opportunity(
        Name = 'O4',
        AccountId = a.Id,
        StageName = 'Closed Won',
        CloseDate = anchor,
        Amount = 400,
        IsWon = true
      )
    );
    insert opps;

    // Request forecast for the account using the controller method
    Test.startTest();
    Map<String, Decimal> fc = ForecastFastController.computeForecastForAccount(
      a.Id,
      6,
      2,
      3
    );
    Test.stopTest();

    // We expect a non-empty forecast map with horizon-sized results
    System.assertNotEquals(null, fc, 'Forecast map should not be null');
    System.assertEquals(
      3,
      fc.size(),
      'Horizon should produce 3 forecast months'
    );
    for (String k : fc.keySet()) {
      System.assertNotEquals(
        null,
        fc.get(k),
        'Forecast value should not be null'
      );
    }
  }
}
