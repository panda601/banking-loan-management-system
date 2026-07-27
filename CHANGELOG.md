# Changelog - Banking Loan Management System (BLMS)

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-07-27

### Added
- **Data Model**: Implemented `Customer__c`, `Loan_Application__c`, `EMI_Schedule__c`, `Guarantor__c`, `Loan_Document__c`, and `Payment__c` custom objects.
- **Apex Service Layer**:
  - `BLMS_LoanApplicationService`: Financial EMI compounding formulas, credit qualification (<600 rejected, >=750 pre-approved), and automated EMI schedule generation on disbursal.
  - `BLMS_PaymentService`: Sequential EMI payment allocation algorithm.
  - `BLMS_LoanApplicationSelector`: FLS/CRUD compliant SOQL query selector layer.
  - `BLMS_EMIScheduleBatch`: Daily batch job tracking overdue EMIs and escalating defaulted loans (>90 days).
  - `BLMS_TestDataFactory`: Unit test factory for test data provisioning.
- **Lightning Web Components**:
  - `blmsApplicationDashboard`, `blmsEligibilityCalculator`, `blmsKpiCard`, `applicationWizard`, `applicationStatusTracker`, `documentViewer`, `approvalCenter`, `quickActionsPanel`, `emptyState`, and `errorBoundary`.
- **Security & Access**: Custom Permission Sets (`PS_Loan_Approval`, `PS_Finance_Operations`, `PS_Document_Verification`, `PS_Reporting_Analytics`, `Admin_Access`), role hierarchy, and sharing rules.
- **DevOps**: Automated GitHub Actions workflow (`blms-cicd.yml`) for PMD static security audit, ESLint, Prettier, LWC Jest, and Scratch Org validation.
