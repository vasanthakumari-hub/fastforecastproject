/**
 * Script to create test forecast data for the sales forecasting app
 */
public class CreateTestForecastData {
    
    public static void createTestForecastData() {
        // First, let's find an existing account to associate with
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 1];
        
        if (accounts.size() > 0) {
            Account testAccount = accounts[0];
            
            // Create multiple forecast records for the account
            List<Forecast__c> forecasts = new List<Forecast__c>();
            
            // Create first forecast record
            Forecast__c forecast1 = new Forecast__c(
                AccountId__c = testAccount.Id,
                Amount__c = 125000.00,
                Period__c = 'Q4 2025',
                ForecastDate__c = Date.today().addMonths(1),
                ForecastType__c = 'Revenue'
            );
            forecasts.add(forecast1);
            
            // Create second forecast record
            Forecast__c forecast2 = new Forecast__c(
                AccountId__c = testAccount.Id,
                Amount__c = 150000.00,
                Period__c = 'Q1 2026',
                ForecastDate__c = Date.today().addMonths(3),
                ForecastType__c = 'Pipeline'
            );
            forecasts.add(forecast2);
            
            // Create third forecast record
            Forecast__c forecast3 = new Forecast__c(
                AccountId__c = testAccount.Id,
                Amount__c = 175000.00,
                Period__c = 'Q2 2026',
                ForecastDate__c = Date.today().addMonths(6),
                ForecastType__c = 'Quota'
            );
            forecasts.add(forecast3);
            
            // Insert all forecast records
            if (!forecasts.isEmpty()) {
                insert forecasts;
                
                System.debug('Successfully created ' + forecasts.size() + ' test forecast records');
                System.debug('Associated with account: ' + testAccount.Name);
                
                // Verify the records were created
                List<Forecast__c> createdForecasts = [
                    SELECT Id, AccountId__c, Amount__c, Period__c, ForecastDate__c, ForecastType__c, AccountId__r.Name
                    FROM Forecast__c 
                    WHERE AccountId__c = :testAccount.Id
                    ORDER BY ForecastDate__c
                ];
                
                System.debug('Verified records:');
                for (Forecast__c f : createdForecasts) {
                    System.debug('ID: ' + f.Id + 
                               ', Account: ' + f.AccountId__r.Name + 
                               ', Amount: ' + f.Amount__c + 
                               ', Period: ' + f.Period__c + 
                               ', Date: ' + f.ForecastDate__c);
                }
            }
        } else {
            System.debug('No accounts found in the org. Please create at least one account first.');
        }
    }
}
