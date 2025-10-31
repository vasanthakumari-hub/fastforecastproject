/**
 * Simple test to insert a forecast record
 */
public class SimpleTestInsert {
    public static void insertTestForecast() {
        // Create a forecast record with a hardcoded account ID
        // This assumes you have an account with ID "001XXXXXXXXXXXX" in your org
        // Replace this with an actual account ID from your org
        Forecast__c forecast = new Forecast__c(
            AccountId__c = '001XXXXXXXXXXXX',
            Amount__c = 100000.00,
            Period__c = 'Test Q1 2026',
            ForecastDate__c = Date.today().addMonths(1),
            ForecastType__c = 'Test'
        );
        
        try {
            insert forecast;
            System.debug('Created test forecast record with ID: ' + forecast.Id);
        } catch (Exception e) {
            System.debug('Error creating forecast record: ' + e.getMessage());
        }
    }
}
