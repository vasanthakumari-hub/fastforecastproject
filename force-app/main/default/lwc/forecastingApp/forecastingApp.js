import { LightningElement, api, track } from "lwc";
import calculateAndSaveForecast from "@salesforce/apex/ForecastController.calculateAndSaveForecast";
import getAccountForecasts from "@salesforce/apex/ForecastController.getAccountForecasts";
import getAllForecasts from "@salesforce/apex/ForecastController.getAllForecasts";

export default class ForecastingApp extends LightningElement {
  @api recordId;
  @track forecasts = [];
  @track isLoading = false;
  @track error = undefined;

  connectedCallback() {
    // If we have a recordId, fetch data for that specific record
    if (this.recordId) {
      this.fetchForecasts(this.recordId);
    } else {
      // If no recordId, fetch all forecasts to show some data
      this.fetchAllForecasts();
    }
  }

  fetchForecasts(accountId) {
    this.isLoading = true;
    this.error = undefined;
    getAccountForecasts({ accountId })
      .then((result) => {
        this.forecasts = result;
        console.log("Fetched forecasts:", this.forecasts);
      })
      .catch((error) => {
        console.error("Error fetching forecasts:", error);
        this.error = error;
      })
      .finally(() => {
        this.isLoading = false;
      });
  }

  fetchAllForecasts() {
    this.isLoading = true;
    this.error = undefined;
    getAllForecasts()
      .then((result) => {
        this.forecasts = result;
        console.log("Fetched all forecasts:", this.forecasts);
      })
      .catch((error) => {
        console.error("Error fetching all forecasts:", error);
        this.error = error;
      })
      .finally(() => {
        this.isLoading = false;
      });
  }

  // Add a method to trigger forecast calculation
  handleCalculateForecast() {
    // Call the Apex method to calculate and save forecast
    this.isLoading = true;
    this.error = undefined;
    calculateAndSaveForecast({ accountId: this.recordId })
      .then((result) => {
        // Refresh the forecasts after calculation
        if (this.recordId) {
          this.fetchForecasts(this.recordId);
        } else {
          this.fetchAllForecasts();
        }
        alert(result.message);
      })
      .catch((error) => {
        console.error("Error calculating forecast:", error);
        this.error = error;
        alert("Error calculating forecast: " + error.body.message);
      })
      .finally(() => {
        this.isLoading = false;
      });
  }
}
