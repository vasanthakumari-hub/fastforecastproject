// Debug script to check field names and create a test forecast record
try {
    // First, let's check what accounts exist
    List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 3];
    System.debug('Found ' + accounts.size() + ' accounts:');
    for(Account acc : accounts) {
        System.debug('Account: ' + acc.Name + ' (ID: ' + acc.Id + ')');
    }
    
    if (accounts.size() > 0) {
        Account testAccount = accounts[0]; // Use first account
        
        // Try to create a forecast record with debug info
        System.debug('Creating forecast record for account: ' + testAccount.Name);
        
        // Check what fields are actually available in Forecast__c
        Schema.DescribeSObjectResult objResult = Forecast__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> fields = objResult.fields.getMap();
        
        System.debug('Available fields in Forecast__c:');
        for(String fieldName : fields.keySet()) {
            System.debug('  ' + fieldName);
        }
        
        // Try creating with the field names we know should exist
        Forecast__c newForecast = new Forecast__c(
            AccountId__c = testAccount.Id,
            Amount__c = 125000.00,
            Period__c = 'Q4 2025',
            ForecastDate__c = Date.today().addMonths(1),
            ForecastType__c = 'Revenue'
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
        System.debug('No accounts found in the org');
    }
} catch(Exception e) {
    System.debug('Error creating record: ' + e.getMessage());
    System.debug('Error type: ' + e.getTypeName());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
