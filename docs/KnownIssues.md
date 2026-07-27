# Known Issues & Workarounds - BLMS

## Overview
Current known operational considerations and workaround instructions.

---

## 1. Issue Log

| Issue ID | Category | Description | Workaround | Status |
| :--- | :--- | :--- | :--- | :--- |
| **ISSUE-101** | Apex Batch | Batch execution beyond 10,000 records requires custom batch size tweaking. | Run batch with scope size 200 via `Database.executeBatch(new BLMS_EMIScheduleBatch(), 200)`. | Open / Documented |
| **ISSUE-102** | LWC Display | Large numbers of EMI schedules (> 120 months) cause table scroll latency in mobile view. | Pagination added to `blmsApplicationDashboard` LWC. | Resolved in v1.0.0 |
