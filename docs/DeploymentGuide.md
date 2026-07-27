# Deployment & Operations Guide - BLMS

## Prerequisites
- Salesforce CLI (`sf`) v2.0+
- Node.js v20.x
- DevHub-enabled Salesforce Org

---

## 1. Local Scratch Org Setup

```bash
# 1. Clone repository
git clone https://github.com/panda601/banking-loan-management-system.git
cd banking-loan-management-system

# 2. Authenticate DevHub
sf org login web --set-default-dev-hub --alias DevHub

# 3. Create Scratch Org
sf org create scratch --definition-file config/project-scratch-def.json --alias BLMS_Scratch --set-default --duration-days 7

# 4. Deploy Metadata
sf project deploy start --target-org BLMS_Scratch --manifest manifest/package.xml

# 5. Assign Permission Sets
sf org assign permset --name Admin_Access --target-org BLMS_Scratch
sf org assign permset --name PS_Loan_Approval --target-org BLMS_Scratch
sf org assign permset --name PS_Finance_Operations --target-org BLMS_Scratch

# 6. Run Unit Tests
sf apex run test --target-org BLMS_Scratch --code-coverage --result-format human

# 7. Open Scratch Org
sf org open --target-org BLMS_Scratch
```

---

## 2. Sandbox & Production Deployment

To validate metadata dry-run in a Target Org:
```bash
sf project deploy validate --target-org TargetOrgAlias --manifest manifest/package.xml --test-level RunLocalTests
```

To execute quick deployment following successful validation:
```bash
sf project deploy quick --target-org TargetOrgAlias --job-id <JOB_ID>
```
