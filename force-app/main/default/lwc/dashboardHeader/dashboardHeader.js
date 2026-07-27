import { LightningElement, api } from 'lwc';
import Id from '@salesforce/user/Id';

export default class DashboardHeader extends LightningElement {
    @api userName = 'Loan Specialist';

    handleRefresh() {
        this.dispatchEvent(new CustomEvent('refresh'));
    }

    handleNewApplication() {
        this.dispatchEvent(new CustomEvent('newapplication'));
    }
}
