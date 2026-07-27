import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class QuickActionsPanel extends LightningElement {
    handleNewLoan() {
        this.showToast('Action', 'Opening New Loan Wizard', 'info');
    }

    handleNewCustomer() {
        this.showToast('Action', 'Opening Customer Intake Form', 'info');
    }

    handleVerifyDocs() {
        this.showToast('Action', 'Opening KYC Document Verification Console', 'info');
    }

    handleCollectEMI() {
        this.showToast('Action', 'Opening EMI Collection Modal', 'info');
    }

    handleApproveLoan() {
        this.showToast('Action', 'Opening Risk Approval Queue', 'info');
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}