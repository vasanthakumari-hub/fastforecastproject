/**
 * Simple class to insert a forecast record for displaying in the sales forecasting app
 */
public class InsertForecastRecord {
  public static void insertForecastRecord() {
    // Get an existing account
    Account testAccount = [SELECT Id FROM Account LIMIT 1];

    // Create a new forecast record with the correct field names
    Forecast__c newForecast = new Forecast__c(
      AccountId__c = testAccount.Id,
      Amount__c = 125000.00,
      Period__c = 'Q4 2025',
      ForecastDate__c = Date.today().addMonths(1),
      ForecastType__c = 'Revenue'
    );

    insert newForecast;

    System.debug(
      'Successfully created test forecast record with Id: ' + newForecast.Id
    );
  }

  // Make it executable as a script
  public static void execute() {
    insertForecastRecord();
  }
}
