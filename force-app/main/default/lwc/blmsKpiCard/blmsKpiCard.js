import { LightningElement, api } from 'lwc';

export default class BlmsKpiCard extends LightningElement {
    @api title;
    @api value;
    @api type = 'number'; // 'number', 'currency', 'percent'
    @api iconName = 'standard:default';
    @api iconVariant = 'default';
    @api trendValue;
    @api trendDirection = 'up'; // 'up', 'down'

    get formattedValue() {
        if (this.value === undefined || this.value === null) return '-';
        if (this.type === 'currency') {
            return new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 }).format(this.value);
        } else if (this.type === 'percent') {
            return `${Number(this.value).toFixed(1)}%`;
        }
        return new Intl.NumberFormat('en-IN').format(this.value);
    }

    get trendClass() {
        return this.trendDirection === 'up' ? 'trend-badge-up' : 'trend-badge-down';
    }

    get trendIcon() {
        return this.trendDirection === 'up' ? 'utility:trending_up' : 'utility:trending_down';
    }
}
