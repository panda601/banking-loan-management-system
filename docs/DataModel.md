# Data Model & Schema Documentation - BLMS

## Overview
The BLMS data model encapsulates borrower details, loan applications, guarantors, KYC verification documents, generated EMI installment schedules, and payment transactional ledgers.

---

## 1. Entity-Relationship Diagram

```mermaid
erDiagram
    Customer__c ||--o{ Loan_Application__c : "applies for"
    Loan_Application__c ||--o{ Guarantor__c : "backed by"
    Loan_Application__c ||--o{ Loan_Document__c : "requires"
    Loan_Application__c ||--o{ EMI_Schedule__c : "generates"
    Loan_Application__c ||--o{ Payment__c : "receives"

    Customer__c {
        string Name PK
        string Customer_External_ID__c SK
        string Aadhaar_Code__c
        string PAN_Code__c
        number Credit_Score__c
        currency Monthly_Salary_Amount__c
        string Employment_Type__c
    }

    Loan_Application__c {
        string Name PK
        id Customer__c FK
        string Loan_Type__c
        currency Loan_Amount__c
        number Loan_Tenure_Months__c
        percent Interest_Rate_Percent__c
        currency EMI_Amount__c
        string Loan_Status__c
        string Eligibility_Status__c
        date Disbursed_Date__c
    }

    EMI_Schedule__c {
        string Name PK
        id Loan_Application__c FK
        number EMI_Number__c
        date Due_Date__c
        currency EMI_Amount__c
        currency Principal_Amount__c
        currency Interest_Amount__c
        currency Outstanding_Balance_Amount__c
        boolean Is_Paid_Flag__c
    }

    Payment__c {
        string Name PK
        id Loan_Application__c FK
        currency Payment_Amount__c
        date Payment_Date__c
        string Payment_Mode__c
        string Payment_Status__c
        string Transaction_ID__c
    }
```

---

## 2. Object Specifications

| Object Name | API Name | Type | Key Fields | Relationship |
| :--- | :--- | :--- | :--- | :--- |
| **Customer** | `Customer__c` | Custom Object | `Aadhaar_Code__c`, `PAN_Code__c`, `Credit_Score__c`, `Monthly_Salary_Amount__c` | Parent of Loans |
| **Loan Application** | `Loan_Application__c` | Custom Object | `Loan_Amount__c`, `Loan_Tenure_Months__c`, `Interest_Rate_Percent__c`, `EMI_Amount__c`, `Loan_Status__c` | Master-Detail / Lookup |
| **Guarantor** | `Guarantor__c` | Custom Object | `Guarantor_Name__c`, `Relationship__c`, `Annual_Income__c` | Lookup to Loan |
| **Loan Document** | `Loan_Document__c` | Custom Object | `Document_Type__c`, `Verification_Status__c`, `Verified_Date__c` | Master-Detail |
| **EMI Schedule** | `EMI_Schedule__c` | Custom Object | `EMI_Number__c`, `Due_Date__c`, `EMI_Amount__c`, `Is_Paid_Flag__c` | Master-Detail |
| **Payment** | `Payment__c` | Custom Object | `Payment_Amount__c`, `Payment_Mode__c`, `Transaction_ID__c`, `Payment_Status__c` | Master-Detail |
