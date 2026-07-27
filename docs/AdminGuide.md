# Administrator Operations Handbook - BLMS

## Overview
Operational guidance for Salesforce Administrators managing the Banking Loan Management System.

---

## 1. User Onboarding & Permission Assignment

Assign the appropriate Permission Sets based on operational roles:
- **Credit Risk Officer**: Assign `PS_Loan_Approval`.
- **Finance & Disbursal Officer**: Assign `PS_Finance_Operations`.
- **KYC Specialist**: Assign `PS_Document_Verification`.
- **Reporting Executive**: Assign `PS_Reporting_Analytics`.

---

## 2. Scheduling Daily Overdue EMI Batch Job

To activate the daily automated EMI delinquency batch engine in Apex Setup or Developer Console:
```apex
BLMS_EMIScheduleBatch batchJob = new BLMS_EMIScheduleBatch();
System.schedule('BLMS Overdue EMI Daily Engine', '0 0 1 * * ?', batchJob);
```

---

## 3. Monitoring & Analytics
Administrators can inspect key system metrics via the **BLMS Command Center** app tab or standard reports under the **Banking & Loan Reports** folder.
