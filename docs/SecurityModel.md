# Security & Access Control Model - BLMS

## Overview
BLMS implements a Least Privilege Access model utilizing Salesforce Organization-Wide Defaults (OWD), Role Hierarchies, Custom Permission Sets, and Runtime FLS/CRUD Security Checks.

---

## 1. Security Architecture Diagram

```mermaid
graph TD
    User[Salesforce User] --> Role[Role Hierarchy]
    Role --> OWD[Org-Wide Defaults: Private]
    
    subgraph Permission Sets
        PS1[PS_Loan_Approval] -->|Approve/Reject| Loan[Loan_Application__c]
        PS2[PS_Finance_Operations] -->|Disburse & Post Payments| Pay[Payment__c]
        PS3[PS_Document_Verification] -->|Audit KYC| Doc[Loan_Document__c]
        PS4[Admin_Access] -->|Full Access| All[System Objects]
    end

    subgraph Data Security Enforcements
        SOQL[WITH USER_MODE]
        DML[insert / update as user]
        FLS[Field-Level Security]
    end

    Role --> Permission Sets
    Permission Sets --> Data Security Enforcements
```

---

## 2. Organization-Wide Defaults (OWD) & Sharing
- `Customer__c`: **Private**
- `Loan_Application__c`: **Private**
- `EMI_Schedule__c`: **Controlled by Parent** (Master-Detail)
- `Payment__c`: **Controlled by Parent** (Master-Detail)
- `Loan_Document__c`: **Controlled by Parent** (Master-Detail)

---

## 3. Enterprise Permission Sets

| Permission Set API Name | Role / User Persona | Assigned Capabilities |
| :--- | :--- | :--- |
| `PS_Loan_Approval` | Credit Risk Managers & Branch Managers | Full read/edit/approval rights on Loan Applications |
| `PS_Finance_Operations` | Finance Officers & Accountants | Access to Payment creation, disbursal status updates, EMI schedules |
| `PS_Document_Verification` | KYC Compliance Officers | Verification rights on Loan Documents and Customer Identity |
| `PS_Reporting_Analytics` | Executives & Auditors | Read-only access to standard reports, dashboards, and loan data |
| `PS_Report_Export_Restricted` | High-Security Persona | Disables data export to prevent PII leaks |
| `Admin_Access` | System Administrators | Full CRUD / View All / Modify All on BLMS objects |
