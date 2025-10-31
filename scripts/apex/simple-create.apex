// Simple test to create a record with field names that we know exist
// Let's try to understand what field names are actually available

try {
    // First check if we can create a record with minimal fields
    Account testAccount = [SELECT Id FROM Account LIMIT 1];
    
    if (testAccount != null) {
        // Try creating with the field we know exists in the metadata
        Forecast__c newForecast = new Forecast__c(
            AccountId__c = testAccount.Id,
            Amount__c = 75000.00,
            Period__c = 'Test Period',
            ForecastDate__c = Date.today(),
            ForecastType__c = 'Test'
        );
        
        insert newForecast;
        
        System.debug('SUCCESS: Created record with ID: ' + newForecast.Id);
        System.debug('Created record details:');
        System.debug('Account ID: ' + newForecast.AccountId__c);
        System.debug('Amount: ' + newForecast.Amount__c);
        System.debug('Period: ' + newForecast.Period__c);
        System.debug('Forecast Date: ' + newForecast.ForecastDate__c);
        System.debug('Forecast Type: ' + newForecast.ForecastType__c);
    } else {
        System.debug('No accounts found');
    }
} catch(Exception e) {
    System.debug('Error creating record: ' + e.getMessage());
    System.debug('Error type: ' + e.getTypeName());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
