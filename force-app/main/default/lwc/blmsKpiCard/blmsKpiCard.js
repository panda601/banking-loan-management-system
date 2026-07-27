import { LightningElement, api } from 'lwc';

export default class BlmsKpiCard extends LightningElement {
    @api title;
    @api value;
    @api type = 'number'; // 'number', 'currency', 'percent'
    @api iconName;
    @api iconVariant = 'default';
    @api trendValue;
    @api trendDirection = 'up'; // 'up', 'down'
    @api variant = 'default'; // 'default', 'success', 'warning', 'error', 'brand'

    get formattedValue() {
        if (this.value === undefined || this.value === null) return '-';
        if (this.type === 'currency') {
            return new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 }).format(this.value);
        } else if (this.type === 'percent') {
            return `${Number(this.value).toFixed(1)}%`;
        }
        return new Intl.NumberFormat('en-IN').format(this.value);
    }

    get cardClass() {
        let baseClass = 'slds-card slds-p-around_medium blms-kpi-card';
        if (this.variant === 'brand') baseClass += ' slds-theme_alt-inverse';
        else if (this.variant === 'success') baseClass += ' slds-theme_success';
        else if (this.variant === 'warning') baseClass += ' slds-theme_warning';
        else if (this.variant === 'error') baseClass += ' slds-theme_error';
        return baseClass;
    }

    get trendClass() {
        return this.trendDirection === 'up' 
            ? 'slds-badge slds-theme_success slds-m-left_small' 
            : 'slds-badge slds-theme_error slds-m-left_small';
    }

    get trendIcon() {
        return this.trendDirection === 'up' ? 'utility:trending_up' : 'utility:trending_down';
    }
}
