# Automation & Business Workflows - BLMS

## Overview
BLMS utilizes record-triggered triggers, service layers, scheduled batches, and approval processes to streamline loan management.

---

## 1. Credit Qualification & EMI Generation Workflow

```mermaid
flowchart TD
    Start([Loan Application Created]) --> CreditCheck{Credit Score Check}
    CreditCheck -- < 600 --> Rejected[Set Eligibility Status: Rejected]
    CreditCheck -- >= 750 --> PreApproved[Set Eligibility Status: Pre-Approved]
    CreditCheck -- 600 to 749 --> Eligible[Set Eligibility Status: Eligible]
    
    PreApproved --> Approval[Manager Approval Workflow]
    Eligible --> Approval

    Approval -- Approved & Disbursed --> DisbursalTrigger[Trigger: BLMS_LoanApplicationTrigger]
    DisbursalTrigger --> EMIGenerator[Service: BLMS_LoanApplicationService.generateEMISchedulesOnDisbursal]
    EMIGenerator --> EMITable[Insert Monthly EMI_Schedule__c Records]
```

---

## 2. Payment Allocation Engine

When a customer submits a `Payment__c` with status `Completed`:
1. `BLMS_PaymentTrigger` delegates to `BLMS_PaymentService.processIncomingPayments`.
2. The service queries all unpaid `EMI_Schedule__c` records ordered by `EMI_Number__c ASC`.
3. It allocates the payment amount sequentially to settle outstanding installments, marks settled EMIs `Is_Paid_Flag__c = true`, updates `Paid_Date__c`, and updates the parent `Loan_Application__c` total paid metrics.
