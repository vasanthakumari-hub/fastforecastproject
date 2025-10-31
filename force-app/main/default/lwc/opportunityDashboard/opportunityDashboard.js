import { LightningElement, track, api } from "lwc";
import getOpenOpportunities from "@salesforce/apex/OpportunityDashboardController.getOpenOpportunities";

export default class OpportunityDashboard extends LightningElement {
  @track opportunities = [];
  @track isLoading = false;
  @track error = undefined;

  connectedCallback() {
    this.loadOpenOpportunities();
  }

  async loadOpenOpportunities() {
    this.isLoading = true;
    this.error = undefined;

    try {
      const result = await getOpenOpportunities();
      this.opportunities = result;
      console.log("Loaded opportunities:", result);
    } catch (error) {
      console.error("Error loading opportunities:", error);
      this.error = error;
    } finally {
      this.isLoading = false;
    }
  }
}
