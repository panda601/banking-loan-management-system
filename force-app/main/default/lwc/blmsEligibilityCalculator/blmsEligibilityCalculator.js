import { LightningElement, api, track } from 'lwc';

export default class BlmsEligibilityCalculator extends LightningElement {
    @api monthlySalary = 75000;
    @track loanAmount = 500000;
    @track interestRate = 10.5;
    @track tenureMonths = 24;

    get calculatedEMI() {
        if (!this.loanAmount || !this.interestRate || !this.tenureMonths) return 0;
        const monthlyRate = (this.interestRate / 100) / 12;
        const emi = (this.loanAmount * monthlyRate * Math.pow(1 + monthlyRate, this.tenureMonths)) / 
                    (Math.pow(1 + monthlyRate, this.tenureMonths) - 1);
        return Math.round(emi);
    }

    get dtiRatio() {
        if (!this.monthlySalary || this.monthlySalary <= 0) return 0;
        return Number(((this.calculatedEMI / this.monthlySalary) * 100).toFixed(1));
    }

    get isEligible() {
        return this.dtiRatio > 0 && this.dtiRatio <= 50;
    }

    get dtiVariant() {
        if (this.dtiRatio <= 40) return 'success';
        if (this.dtiRatio <= 50) return 'warning';
        return 'error';
    }

    handleSalaryChange(event) { this.monthlySalary = Number(event.target.value); }
    handleAmountChange(event) { this.loanAmount = Number(event.target.value); }
    handleRateChange(event) { this.interestRate = Number(event.target.value); }
    handleTenureChange(event) { this.tenureMonths = Number(event.target.value); }
}
