import { LightningElement, track } from 'lwc';

// Temporary client-side demo implementation to avoid requiring
// the Apex controller during metadata deployment. Restore the Apex
// import and logic after `ForecastFastController` is present in the org.
export default class ForecastfastApp extends LightningElement {
  @track forecasts = [];
  @track isLoading = false;
  @track error;

  connectedCallback() {
    // Hard-coded demo series (YYYY-MM -> amount)
    this.forecasts = [
      { month: '2025-06', amount: 1200 },
      { month: '2025-07', amount: 1300 },
      { month: '2025-08', amount: 1250 },
      { month: '2025-09', amount: 1400 },
      { month: '2025-10', amount: 1500 }
    ];
  }
}
