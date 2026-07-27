import { LightningElement, api } from 'lwc';

export default class DashboardTasks extends LightningElement {
    @api rawTasks = [];

    get hasTasks() {
        return this.rawTasks && this.rawTasks.length > 0;
    }

    get tasks() {
        if (!this.rawTasks) return [];
        return this.rawTasks.map(t => {
            return {
                ...t,
                priorityClass: t.priority === 'High' ? 'prio-badge prio-high' : 'prio-badge prio-normal'
            };
        });
    }

    handleOpenTask(event) {
        const taskId = event.currentTarget.dataset.id;
        this.dispatchEvent(new CustomEvent('opentask', { detail: { recordId: taskId } }));
    }
}
