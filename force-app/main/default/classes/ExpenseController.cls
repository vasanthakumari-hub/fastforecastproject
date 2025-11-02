/**
 * Controller for expense tracking actions.
 * Improvements:
 * - input validation
 * - bulk create/update helpers
 * - cacheable query methods for LWC performance
 * - clearer, user-friendly error messages
 */
/*checking the newly added
/* Newly tested comment
public with sharing class ExpenseController {

  // Single-record create kept for convenience. Prefer bulk API below in integrations.
  @AuraEnabled
  public static Expense__c createExpense(Expense__c expense) {
    if (expense == null) {
      throw new AuraHandledException('Invalid request: expense is required.');
    }

    // Set sensible defaults
    if (String.isBlank(expense.Status__c)) {
      expense.Status__c = 'Submitted';
    }

    try {
      insert expense;
      return expense;
    } catch (DmlException e) {
      // Surface meaningful DML exception to the client
      String msg = 'Failed to create expense: ' + getDmlMessage(e);
      throw new AuraHandledException(msg);
    }
  }

  // Bulk create - safer for integrations and batching
  @AuraEnabled
  public static List<Expense__c> createExpenses(List<Expense__c> expenses) {
    if (expenses == null || expenses.isEmpty()) {
      return new List<Expense__c>();
    }

    for (Expense__c e : expenses) {
      if (String.isBlank(e.Status__c)) {
        e.Status__c = 'Submitted';
      }
    }

    try {
      insert expenses;
      return expenses;
    } catch (DmlException e) {
      String msg = 'Failed to create expenses: ' + getDmlMessage(e);
      throw new AuraHandledException(msg);
    }
  }

  @AuraEnabled
  public static Expense__c updateExpense(Expense__c expense) {
    if (expense == null || expense.Id == null) {
      throw new AuraHandledException('Invalid request: expense Id is required for update.');
    }

    try {
      update expense;
      return expense;
    } catch (DmlException e) {
      String msg = 'Failed to update expense: ' + getDmlMessage(e);
      throw new AuraHandledException(msg);
    }
  }

  // Bulk update helper
  @AuraEnabled
  public static List<Expense__c> updateExpenses(List<Expense__c> expenses) {
    if (expenses == null || expenses.isEmpty()) {
      return new List<Expense__c>();
    }

    for (Expense__c e : expenses) {
      if (e.Id == null) {
        throw new AuraHandledException('Each expense being updated must include an Id.');
      }
    }

    try {
      update expenses;
      return expenses;
    } catch (DmlException e) {
      String msg = 'Failed to update expenses: ' + getDmlMessage(e);
      throw new AuraHandledException(msg);
    }
  }

  // Read-only cached methods for LWCs. Use cacheable=true to improve performance.
  @AuraEnabled(cacheable=true)
  public static List<Expense__c> getExpenses() {
    return [
      SELECT Id, Name, Amount__c, Category__c, Date__c, Status__c
      FROM Expense__c
      ORDER BY Date__c DESC
    ];
  }

  @AuraEnabled(cacheable=true)
  public static List<Expense__c> getExpensesByStatus(String status) {
    if (String.isBlank(status)) {
      return new List<Expense__c>();
    }

    return [
      SELECT Id, Name, Amount__c, Category__c, Date__c, Status__c
      FROM Expense__c
      WHERE Status__c = :status
      ORDER BY Date__c DESC
    ];
  }

  // Helper to build a compact message from DmlException
  private static String getDmlMessage(DmlException e) {
    // Return the first DML error's status code and message when available
    if (e.getNumDml() > 0 && e.getDmlFields(0) != null) {
      try {
        // Build short summary; don't expose internal stack traces
        return e.getDmlType(0) + ' - ' + e.getMessage();
      } catch (Exception ignored) {
        return e.getMessage();
      }
    }
    return e.getMessage();
  }
}
