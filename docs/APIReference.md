# Apex API & Service Reference - BLMS

## Overview
Reference documentation for public service methods in BLMS Apex API layer.

---

## 1. `BLMS_LoanApplicationService`

### `calculateMonthlyEMI(List<Loan_Application__c> loanList)`
Calculates monthly EMI using standard formula `[P x R x (1+R)^N]/[(1+R)^N-1]` and updates `EMI_Amount__c` on each loan record.

### `validateCreditEligibility(List<Loan_Application__c> loanList, Map<Id, Customer__c> customerMap)`
Evaluates credit score thresholds:
- Score < 600: Rejects loan and adds field error.
- Score >= 750: Sets `Eligibility_Status__c = 'Pre-Approved'`.
- Score 600 to 749: Sets `Eligibility_Status__c = 'Eligible'`.

### `generateEMISchedulesOnDisbursal(List<Loan_Application__c> newLoans, Map<Id, Loan_Application__c> oldMap)`
Generates N monthly `EMI_Schedule__c` child records when `Loan_Status__c` shifts to `Disbursed`.

---

## 2. `BLMS_PaymentService`

### `processIncomingPayments(List<Payment__c> newPayments)`
Allocates completed payment funds to unpaid EMI installments sequentially by `EMI_Number__c`.

---

## 3. `BLMS_LoanApplicationSelector`

### `getLoansWithEMISchedules(Set<Id> loanIds)`
Queries loans with child EMI schedules using `WITH USER_MODE`.
