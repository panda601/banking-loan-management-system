# Testing & Quality Assurance Guide - BLMS

## Overview
BLMS includes comprehensive automated unit tests across Apex controllers, service classes, selectors, batch jobs, and triggers using `BLMS_TestDataFactory`.

---

## 1. Apex Test Suite Coverage Matrix

| Test Class Name | Target Class | Coverage Target | Key Scenarios Tested |
| :--- | :--- | :--- | :--- |
| `BLMS_LoanApplicationTriggerTest` | Trigger & Handler | > 90% | Loan creation, status change to Disbursed, EMI generation |
| `BLMS_LoanServiceTest` | Service Layer | > 95% | Credit qualification (Reject <600, Pre-Approve >=750), EMI math |
| `BLMS_PaymentTriggerTest` | Payment Service | > 90% | Sequential EMI allocation, payment status updates |
| `BLMS_EMIScheduleBatchTest` | Batch Engine | > 90% | Delinquent EMI tracking, 90-day overdue default escalation |

---

## 2. Command Line Execution

Run all Apex unit tests and output code coverage:
```bash
sf apex run test --target-org BLMS_Scratch --code-coverage --result-format human --wait 20
```

Run LWC Jest Unit Tests:
```bash
npm run test:unit:coverage
```
