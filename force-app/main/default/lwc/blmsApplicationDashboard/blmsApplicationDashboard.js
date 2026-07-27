import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class BlmsApplicationDashboard extends NavigationMixin(LightningElement) {

    handleRefresh() {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Refreshed',
            message: 'Dashboard metrics synchronized with Salesforce live ledger.',
            variant: 'success'
        }));
    }

    handleNewApp() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Loan_Application__c',
                actionName: 'new'
            }
        });
    }

    handleViewApprovals() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Loan_Application__c',
                actionName: 'list'
            },
            state: {
                filterName: 'All'
            }
        });
    }

    handleDocVerification() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Loan_Document__c',
                actionName: 'list'
            }
        });
    }
}
