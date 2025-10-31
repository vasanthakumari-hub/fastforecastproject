Account a = new Account(Name='FF Test Account Smoke 20251031');
insert a;

List<Opportunity> ops = new List<Opportunity>{
    new Opportunity(Name='Opp 1', AccountId=a.Id, CloseDate=Date.today().addMonths(-2), StageName='Closed Won', Amount=1000),
    new Opportunity(Name='Opp 2', AccountId=a.Id, CloseDate=Date.today().addMonths(-1), StageName='Closed Won', Amount=1200),
    new Opportunity(Name='Opp 3', AccountId=a.Id, CloseDate=Date.today(), StageName='Closed Won', Amount=1100)
};
insert ops;

Map<String, Decimal> res = ForecastFastController.computeForecastForAccount(a.Id, 6, 3, 3);
System.debug('FORECAST_RESULT: ' + JSON.serialize(res));

List<Forecast__c> f = [SELECT Id, Period__c, Amount__c, ForecastDate__c, ForecastType__c FROM Forecast__c WHERE AccountId__c = :a.Id ORDER BY ForecastDate__c];
System.debug('FORECAST_ROWS: ' + JSON.serialize(f));
