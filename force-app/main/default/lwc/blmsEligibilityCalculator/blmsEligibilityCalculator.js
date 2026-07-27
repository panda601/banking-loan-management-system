import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BlmsEligibilityCalculator extends LightningElement {
    @track monthlySalary = 75000;
    @track loanAmount = 500000;
    @track interestRate = 10.5;
    @track tenureMonths = 36;

    handleSalaryChange(event) {
        this.monthlySalary = Number(event.target.value);
    }

    handleAmountChange(event) {
        this.loanAmount = Number(event.target.value);
    }

    handleRateChange(event) {
        this.interestRate = Number(event.target.value);
    }

    handleTenureChange(event) {
        this.tenureMonths = Number(event.target.value);
    }

    handleReset() {
        this.monthlySalary = 75000;
        this.loanAmount = 500000;
        this.interestRate = 10.5;
        this.tenureMonths = 36;
    }

    handleSaveScenario() {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Scenario Saved',
            message: `Saved calculation scenario for ₹${this.loanAmount.toLocaleString('en-IN')} loan request.`,
            variant: 'success'
        }));
    }

    get calculatedEMI() {
        if (!this.loanAmount || !this.tenureMonths || this.tenureMonths <= 0) return '0';
        const monthlyRate = (this.interestRate || 10.5) / 12 / 100;
        const n = this.tenureMonths;
        const rateFactor = Math.pow(1 + monthlyRate, n);
        const emi = (this.loanAmount * monthlyRate * rateFactor) / (rateFactor - 1);
        return isNaN(emi) ? '0' : Math.round(emi).toLocaleString('en-IN');
    }

    get dtiRatio() {
        if (!this.monthlySalary || this.monthlySalary <= 0) return 0;
        const emiVal = Number(String(this.calculatedEMI).replace(/,/g, ''));
        const ratio = (emiVal / this.monthlySalary) * 100;
        return isNaN(ratio) ? 0 : ratio.toFixed(1);
    }

    get isEligible() {
        return Number(this.dtiRatio) <= 50;
    }
}
