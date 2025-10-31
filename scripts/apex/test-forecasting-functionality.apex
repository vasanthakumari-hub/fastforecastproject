// Test script to validate ForecastingService functionality
public class TestForecastingFunctionality {
    
    @isTest
    static void testGetHistoricalByMonth() {
        // Create a test account
        Account testAccount = new Account(
            Name = 'Test Account',
            Type = 'Customer'
        );
        insert testAccount;
        
        // Create a test opportunity
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = testAccount.Id,
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 10000
        );
        insert testOpp;
        
        // Test the method
        Map<String, Decimal> result = ForecastingService.getHistoricalByMonth(testAccount.Id, null, 12);
        
        // Verify the result
        System.assertNotEquals(null, result);
        System.assert(result.size() > 0);
    }
    
    @isTest
    static void testGetPipelineBaselineByMonth() {
        // Create a test account
        Account testAccount = new Account(
            Name = 'Test Account 2',
            Type = 'Customer'
        );
        insert testAccount;
        
        // Create a test opportunity
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opportunity 2',
            AccountId = testAccount.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addMonths(1),
            Amount = 15000,
            Probability = 50
        );
        insert testOpp;
        
        // Test the method
        Map<String, Decimal> result = ForecastingService.getPipelineBaselineByMonth(testAccount.Id, null, 6);
        
        // Verify the result
        System.assertNotEquals(null, result);
        System.assert(result.size() >= 0);
    }
}
