import { LightningElement, track, wire } from "lwc";
import createExpense from "@salesforce/apex/ExpenseController.createExpense";
import updateExpense from "@salesforce/apex/ExpenseController.updateExpense";
import getExpenses from "@salesforce/apex/ExpenseController.getExpenses";
import getExpensesByStatus from "@salesforce/apex/ExpenseController.getExpensesByStatus";

export default class ExpenseDashboard extends LightningElement {
  @track expenses = [];
  @track filteredExpenses = [];
  @track showAddForm = false;

  // Form fields
  @track newExpense = {
    Name: "",
    Amount__c: "",
    Category__c: "",
    Date__c: "",
    Status__c: "Submitted"
  };

  @track selectedStatus = "All";

  @wire(getExpenses)
  wiredExpenses({ error, data }) {
    if (data) {
      this.expenses = data;
      this.filteredExpenses = data;
    } else if (error) {
      console.error("Error loading expenses:", error);
    }
  }

  handleInputChange(event) {
    const field = event.target.name;
    this.newExpense[field] = event.target.value;
  }

  handleAddExpense() {
    this.showAddForm = true;
    this.resetForm();
  }

  resetForm() {
    this.newExpense = {
      Name: "",
      Amount__c: "",
      Category__c: "",
      Date__c: "",
      Status__c: "Submitted"
    };
  }

  async handleSaveExpense() {
    try {
      // Validate required fields
      if (
        !this.newExpense.Name ||
        !this.newExpense.Amount__c ||
        !this.newExpense.Category__c
      ) {
        this.showToast("Error", "Please fill in all required fields", "error");
        return;
      }

      // Convert amount to decimal
      this.newExpense.Amount__c = parseFloat(this.newExpense.Amount__c);

      // Create the expense
      const result = await createExpense(this.newExpense);

      // Reset form and refresh data
      this.resetForm();
      this.showAddForm = false;

      this.showToast("Success", "Expense created successfully", "success");
    } catch (error) {
      console.error("Error creating expense:", error);
      this.showToast(
        "Error",
        "Failed to create expense: " + error.body.message,
        "error"
      );
    }
  }

  handleCancel() {
    this.showAddForm = false;
    this.resetForm();
  }

  handleStatusFilterChange(event) {
    this.selectedStatus = event.target.value;
    this.applyFilters();
  }

  applyFilters() {
    if (this.selectedStatus === "All") {
      this.filteredExpenses = this.expenses;
    } else {
      this.filteredExpenses = this.expenses.filter(
        (expense) => expense.Status__c === this.selectedStatus
      );
    }
  }

  handleStatusChange(event) {
    const expenseId = event.target.dataset.id;
    const newStatus = event.target.value;

    // Find the expense and update its status
    const expense = this.expenses.find((e) => e.Id === expenseId);
    if (expense) {
      expense.Status__c = newStatus;

      // Update in the backend
      updateExpense(expense)
        .then(() => {
          this.showToast("Success", "Expense status updated", "success");
          this.applyFilters(); // Refresh the filtered list
        })
        .catch((error) => {
          console.error("Error updating expense:", error);
          this.showToast("Error", "Failed to update expense status", "error");
        });
    }
  }

  showToast(title, message, variant) {
    const evt = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(evt);
  }

  get statusOptions() {
    return [
      { label: "All", value: "All" },
      { label: "Submitted", value: "Submitted" },
      { label: "Approved", value: "Approved" },
      { label: "Rejected", value: "Rejected" }
    ];
  }

  get totalAmount() {
    return this.expenses.reduce(
      (sum, expense) => sum + (expense.Amount__c || 0),
      0
    );
  }

  get submittedCount() {
    return this.expenses.filter((expense) => expense.Status__c === "Submitted")
      .length;
  }

  get approvedCount() {
    return this.expenses.filter((expense) => expense.Status__c === "Approved")
      .length;
  }
}
