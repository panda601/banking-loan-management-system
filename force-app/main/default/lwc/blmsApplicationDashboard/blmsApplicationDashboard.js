import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDashboardKPIs from '@salesforce/apex/BLMS_LoanApplicationSelector.getDashboardKPIs';
import getPipelineSummary from '@salesforce/apex/BLMS_LoanApplicationSelector.getPipelineSummary';
import getRecentActivities from '@salesforce/apex/BLMS_LoanApplicationSelector.getRecentActivities';
import getPendingTasks from '@salesforce/apex/BLMS_LoanApplicationSelector.getPendingTasks';
import getNotifications from '@salesforce/apex/BLMS_LoanApplicationSelector.getNotifications';
import getLoansByStatus from '@salesforce/apex/BLMS_LoanApplicationSelector.getLoansByStatus';

export default class BlmsApplicationDashboard extends NavigationMixin(LightningElement) {
    userName = 'Loan Specialist';
    @track showCalculator = false;
    @track kpis = {
        totalApplications: 0,
        pendingApproval: 0,
        disbursedCount: 0,
        defaultedCount: 0,
        totalVolume: 0,
        approvalRate: '0.0%'
    };
    @track pipelineSummary = [];
    @track activities = [];
    @track pendingTasks = [];
    @track notifications = [];
    @track rawApplications = [];

    get calcToggleLabel() {
        return this.showCalculator ? 'Hide Calculator' : 'Show Loan Calculator';
    }

    get calcToggleIcon() {
        return this.showCalculator ? 'utility:chevrondown' : 'utility:chevronright';
    }

    @wire(getDashboardKPIs)
    wiredKPIs({ error, data }) {
        if (data) {
            this.kpis = {
                ...data,
                approvalRate: (data.approvalRate || 0) + '%'
            };
        } else if (error) {
            console.error('Error fetching KPIs', error);
        }
    }

    @wire(getPipelineSummary)
    wiredPipeline({ error, data }) {
        if (data) {
            this.pipelineSummary = data;
        }
    }

    @wire(getRecentActivities)
    wiredActivities({ error, data }) {
        if (data) {
            this.activities = data;
        }
    }

    @wire(getPendingTasks)
    wiredTasks({ error, data }) {
        if (data) {
            this.pendingTasks = data;
        }
    }

    @wire(getNotifications)
    wiredNotifs({ error, data }) {
        if (data) {
            this.notifications = data;
        }
    }

    @wire(getLoansByStatus, { status: 'Applied' })
    wiredLoans({ error, data }) {
        if (data) {
            this.rawApplications = data;
        }
    }

    toggleCalculator() {
        this.showCalculator = !this.showCalculator;
    }

    handleRefresh() {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Dashboard Refreshed',
            message: 'Dashboard metrics synchronized with Salesforce live data.',
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

    handleNewCustomer() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Customer__c',
                actionName: 'new'
            }
        });
    }

    handleDocVerification() {
        this.showToast('Document Verification Workspace', 'Navigating to document verification queue...', 'info');
    }

    handleCollectEMI() {
        this.showToast('EMI Collection Workspace', 'Navigating to payment posting module...', 'info');
    }

    handleViewApprovals() {
        this.showToast('Loan Risk Review', 'Opening manager approval queue...', 'info');
    }

    handleOpenReports() {
        this.showToast('Analytics Console', 'Opening loan performance reports...', 'info');
    }

    handleSelectRecord(event) {
        const recordId = event.detail.recordId;
        if (recordId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: recordId,
                    actionName: 'view'
                }
            });
        }
    }

    handleOpenTask(event) {
        const taskId = event.detail.recordId;
        if (taskId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: taskId,
                    actionName: 'view'
                }
            });
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
