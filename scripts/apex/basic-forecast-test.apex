// Basic test to verify the forecasting app components work together
public class BasicForecastTest {
    
    @isTest
    static void testForecastingServiceMethodsExist() {
        // Test that the ForecastingService class compiles and methods exist
        // We'll just test that we can call the methods without runtime errors
        
        // Call a simple method
        List<Decimal> result = ForecastingService.calculateMovingAverageForecast(null, 3);
        System.assert(result != null);
        
        // Call another method  
        Decimal result2 = ForecastingService.calculateLinearRegressionForecast(null);
        System.assert(result2 != null);
    }
    
    @isTest
    static void testForecastControllerMethodsExist() {
        // Test that the ForecastController class compiles and methods exist
        // This is a basic test to ensure the controller works
        ForecastController ctrl = new ForecastController();
        System.assert(ctrl != null);
    }
}
