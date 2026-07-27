import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BlmsApplicationDashboard extends LightningElement {
    @track showCalculator = false;

    get calcToggleLabel() {
        return this.showCalculator ? 'Hide Calculator' : 'Open Eligibility Calculator';
    }

    get calcToggleIcon() {
        return this.showCalculator ? 'utility:chevronup' : 'utility:calculator';
    }

    toggleCalculator() {
        this.showCalculator = !this.showCalculator;
    }

    handleRefresh() {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Dashboard Refreshed',
            message: 'Latest loan portfolio metrics loaded.',
            variant: 'success'
        }));
    }

    handleNewApp() {
        this.showToast('Initiate Action', 'Opening New Loan Application Wizard...', 'info');
    }

    handleNewCustomer() {
        this.showToast('Initiate Action', 'Opening Customer Onboarding Form...', 'info');
    }

    handleViewApprovals() {
        this.showToast('Navigation', 'Redirecting to Risk Approval Queue...', 'info');
    }

    handleDocVerification() {
        this.showToast('Navigation', 'Redirecting to KYC Document Auditor...', 'info');
    }

    handleCollectEMI() {
        this.showToast('Initiate Action', 'Opening EMI Payment Posting Modal...', 'info');
    }

    handleOpenReports() {
        this.showToast('Navigation', 'Redirecting to Banking Reports & Dashboards...', 'info');
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
