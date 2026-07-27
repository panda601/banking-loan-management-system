# Release Notes - Banking Loan Management System (BLMS)

## Version 1.0.0 (Initial Production Release)
**Release Date**: July 27, 2026  
**Status**: General Availability (GA)

---

### Highlights & Key Features
- **Native Custom Objects**: Customer, Loan Application, Guarantor, Loan Document, EMI Schedule, and Payment.
- **Automated Financial Calculations**: Auto-calculates monthly EMI installments using interest rate formulas.
- **Credit Score Qualification**: Automated eligibility scoring (Pre-Approved >= 750, Rejected < 600).
- **EMI Engine**: Automatic multi-month EMI schedule generation upon loan disbursal.
- **Payment Settlement**: Sequential EMI payment allocation engine.
- **Overdue Batch Processing**: Daily Apex batch job tracking overdue EMIs and updating defaulted loans.
- **LWC Dashboards**: Interactive executive dashboards, loan wizard, calculator, and KYC document viewer.
- **Security & Roles**: Enterprise Permission Sets (`PS_Loan_Approval`, `PS_Finance_Operations`, `PS_Document_Verification`, `Admin_Access`).
- **DevOps**: Fully automated GitHub Actions CI/CD pipeline with PMD, ESLint, Prettier, and Scratch Org testing.
