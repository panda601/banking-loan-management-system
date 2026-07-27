import { LightningElement, api } from 'lwc';

export default class DashboardActivities extends LightningElement {
    @api activities = [];

    get hasActivities() {
        return this.activities && this.activities.length > 0;
    }
}
