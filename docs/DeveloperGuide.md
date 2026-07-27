# Developer Handbook & Coding Standards - BLMS

## Overview
This guide provides standards and architectural conventions for developers contributing to the BLMS codebase.

---

## 1. Apex Coding Standards
- **Enforce Sharing**: Every Apex class MUST explicitly specify `with sharing` or `without sharing` (service/selector defaults to `with sharing`).
- **Security Guardrails**: Always enforce `WITH USER_MODE` on SOQL queries, and use `insert as user` / `update as user` for DML operations.
- **Bulkification**: Never execute SOQL queries or DML statements inside `for` loops. Process all collections in bulk.
- **Trigger Design**: Triggers MUST be logic-less and delegate execution immediately to dedicated Handler classes.

---

## 2. LWC Coding Standards
- Use camelCase for JS properties and kebab-case for template attributes.
- Handle component errors using standard LDS error utilities or the `errorBoundary` component wrapper.
- Ensure full SLDS styling alignment using design tokens instead of hardcoded pixel CSS.

---

## 3. Git Branching Strategy
- `main`: Production-ready release code.
- `develop`: Integration branch for sprint features.
- `feature/<feature-name>`: Feature development branches.
- `hotfix/<fix-name>`: Production emergency patch branches.
