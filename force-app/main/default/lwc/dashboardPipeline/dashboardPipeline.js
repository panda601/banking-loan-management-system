import { LightningElement, api } from 'lwc';

export default class DashboardPipeline extends LightningElement {
    @api rawApplications = [];

    get hasApplications() {
        return this.rawApplications && this.rawApplications.length > 0;
    }

    get applications() {
        if (!this.rawApplications) return [];
        return this.rawApplications.map(app => {
            let badgeClass = 'badge ';
            switch (app.Loan_Status__c) {
                case 'Approved':
                case 'Sanctioned':
                case 'Disbursed':
                    badgeClass += 'badge-success';
                    break;
                case 'Under Review':
                case 'Applied':
                    badgeClass += 'badge-warning';
                    break;
                case 'Rejected':
                case 'Defaulted':
                    badgeClass += 'badge-danger';
                    break;
                default:
                    badgeClass += 'badge-neutral';
            }

            return {
                ...app,
                CustomerName: app.Customer__r ? app.Customer__r.Name : 'N/A',
                badgeClass
            };
        });
    }

    handleSelectRecord(event) {
        const recId = event.currentTarget.dataset.id;
        this.dispatchEvent(new CustomEvent('selectrecord', { detail: { recordId: recId } }));
    }
}
