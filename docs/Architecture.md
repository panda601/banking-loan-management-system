# System Architecture Document - Banking Loan Management System (BLMS)

## Executive Overview
The **Banking Loan Management System (BLMS)** is an enterprise-grade native Salesforce solution designed for retail banking institutions. It manages end-to-end loan lifecycles—from intake and automated credit qualification to KYC document verification, multi-tier manager approval workflows, financial disbursal, automated EMI schedule creation, and payment ledger reconciliation.

---

## 1. Enterprise System Architecture

```mermaid
graph TD
    Client[Lightning Web Components UI] --> Controllers[Apex Controller / Wire Layer]
    Controllers --> ServiceLayer[BLMS Loan & Payment Service Engine]
    ServiceLayer --> SelectorLayer[BLMS Data Selector Layer]
    SelectorLayer --> Database[(Salesforce Data Cloud / Database)]

    subgraph Core Data Model
        Database --> Customer[Customer__c]
        Customer --> Loan[Loan_Application__c]
        Loan --> EMI[EMI_Schedule__c]
        Loan --> Payment[Payment__c]
        Loan --> Document[Loan_Document__c]
        Loan --> Guarantor[Guarantor__c]
    end

    subgraph Batch Engine
        Batch[BLMS_EMIScheduleBatch] -->|Daily Cron Job| EMI
        Batch -->|Default Escalation| Loan
    end
```

---

## 2. Key Architecture Principles

1. **Separation of Concerns (SOC)**: Strict separation into UI Components (LWC), Application Service Layer (`BLMS_LoanApplicationService`, `BLMS_PaymentService`), Selector Query Layer (`BLMS_LoanApplicationSelector`), and Domain Data Models.
2. **Security First**: Enforced `with sharing` across all classes, explicit CRUD/FLS validation via `WITH USER_MODE`, and system-level permissions via dedicated Permission Sets.
3. **High Performance & Bulkification**: Zero SOQL queries or DML statements inside loops, set-based query execution, and batch processing for heavy data operations.
4. **DevOps Automation**: Native integration with Salesforce DX (`sf`), Scratch Orgs, GitHub Actions CI/CD pipelines, PMD static analysis, ESLint, and Prettier code formatting.
