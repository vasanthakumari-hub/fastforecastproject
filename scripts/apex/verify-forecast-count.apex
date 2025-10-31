/**
 * Simple script to verify forecast record count
 */
public class VerifyForecastCount {
    public static void checkCount() {
        Integer count = [SELECT COUNT() FROM Forecast__c];
        System.debug('Forecast__c record count: ' + count);
    }
}
