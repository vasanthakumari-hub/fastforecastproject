/**
 * Script to insert a test forecast record for displaying in the sales forecasting app
 */
@isTest
public class InsertForecastRecord {
    
    @isTest
    static void insertTestForecast() {
        // First, let's find an existing account to associate with
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        if (testAccount != null) {
            // Create a new forecast record with the correct field names
            Forecast__c newForecast = new Forecast__c(
                AccountId__c = testAccount.Id,
                Amount__c = 125000.00,
                Period__c = 'Q4 2025',
                ForecastDate__c = Date.today().addMonths(1),
                ForecastType__c = 'Revenue'
            );
            
            insert newForecast;
            
            System.debug('Successfully created test forecast record with Id: ' + newForecast.Id);
            System.debug('Record details:');
            System.debug('Account: ' + testAccount.Name);
            System.debug('Amount: ' + newForecast.Amount__c);
            System.debug('Period: ' + newForecast.Period__c);
            System.debug('Forecast Date: ' + newForecast.ForecastDate__c);
            System.debug('Forecast Type: ' + newForecast.ForecastType__c);
        } else {
            System.debug('No accounts found in the org. Please create at least one account first.');
        }
    }
}
