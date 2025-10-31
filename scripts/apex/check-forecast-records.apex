/**
 * Script to check if Forecast__c records exist in the org
 */
public class CheckForecastRecords {
    
    public static void checkForecastRecords() {
        // Count existing forecast records
        Integer recordCount = [SELECT COUNT() FROM Forecast__c];
        
        System.debug('Total Forecast__c records found: ' + recordCount);
        
        if (recordCount > 0) {
            // Display first 5 records
            List<Forecast__c> forecasts = [
                SELECT Id, AccountId__c, Amount__c, Period__c, ForecastDate__c, ForecastType__c, AccountId__r.Name
                FROM Forecast__c 
                LIMIT 5
            ];
            
            System.debug('Sample Forecast records:');
            for (Forecast__c f : forecasts) {
                System.debug('ID: ' + f.Id + 
                           ', Account: ' + f.AccountId__r.Name + 
                           ', Amount: ' + f.Amount__c + 
                           ', Period: ' + f.Period__c);
            }
        } else {
            System.debug('No Forecast__c records found in the org.');
        }
    }
}
