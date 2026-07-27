import { LightningElement, api } from 'lwc';

export default class DashboardNotifications extends LightningElement {
    @api notifications = [];

    get hasNotifications() {
        return this.notifications && this.notifications.length > 0;
    }
}
