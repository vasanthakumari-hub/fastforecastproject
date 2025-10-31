// Create a sample forecast record to test the UI
try {
    // First check if we have an account to associate with
    List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
    
    if (accounts.size() > 0) {
        Account testAccount = accounts[0];
        
        // Create a new forecast record
        Forecast__c newForecast = new Forecast__c(
            AccountId__c = testAccount.Id,
            Amount__c = 125000.00,
            Period__c = 'Q4 2025',
            ForecastDate__c = Date.today().addMonths(1),
            ForecastType__c = 'Revenue'
        );
        
        insert newForecast;
        
        System.debug('SUCCESS: Created sample forecast record with ID: ' + newForecast.Id);
        System.debug('Account: ' + testAccount.Name);
        System.debug('Amount: ' + newForecast.Amount__c);
        System.debug('Period: ' + newForecast.Period__c);
        System.debug('Forecast Date: ' + newForecast.ForecastDate__c);
        System.debug('Forecast Type: ' + newForecast.ForecastType__c);
    } else {
        System.debug('No accounts found in the org');
    }
} catch(Exception e) {
    System.debug('Error creating sample record: ' + e.getMessage());
    System.debug('Error type: ' + e.getTypeName());
}
