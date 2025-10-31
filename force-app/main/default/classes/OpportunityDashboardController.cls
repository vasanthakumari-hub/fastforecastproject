/**
 * Controller class for Opportunity Dashboard component
 */
public with sharing class OpportunityDashboardController {
  @AuraEnabled
  public static List<Map<String, Object>> getOpenOpportunities() {
    List<Map<String, Object>> result = new List<Map<String, Object>>();

    try {
      // Query open opportunities with their related account and contact
      List<Opportunity> opportunities = [
        SELECT Id, Name, Amount, CloseDate, StageName, AccountId, ContactId
        FROM Opportunity
        WHERE IsClosed = FALSE
        ORDER BY CloseDate
      ];

      // Process each opportunity
      for (Opportunity opp : opportunities) {
        Map<String, Object> oppData = new Map<String, Object>();

        // Add opportunity data
        oppData.put(
          'Opportunity',
          new Map<String, Object>{
            'Id' => opp.Id,
            'Name' => opp.Name,
            'Amount' => opp.Amount,
            'CloseDate' => opp.CloseDate,
            'StageName' => opp.StageName
          }
        );

        // Add account data if available
        if (opp.AccountId != null) {
          Account acc = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :opp.AccountId
            LIMIT 1
          ];
          oppData.put(
            'Account',
            new Map<String, Object>{ 'Id' => acc.Id, 'Name' => acc.Name }
          );
        } else {
          oppData.put('Account', null);
        }

        // Add contact data if available
        if (opp.ContactId != null) {
          Contact cont = [
            SELECT Id, Name
            FROM Contact
            WHERE Id = :opp.ContactId
            LIMIT 1
          ];
          oppData.put(
            'Contact',
            new Map<String, Object>{ 'Id' => cont.Id, 'Name' => cont.Name }
          );
        } else {
          oppData.put('Contact', null);
        }

        result.add(oppData);
      }
    } catch (Exception e) {
      System.debug('Error in getOpenOpportunities: ' + e.getMessage());
      // Return empty list on error
      return new List<Map<String, Object>>();
    }

    return result;
  }
}
