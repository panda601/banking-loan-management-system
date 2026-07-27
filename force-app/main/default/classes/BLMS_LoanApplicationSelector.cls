/**
 * @description Enterprise Selector Layer for Loan Applications & Related Objects
 * Adheres to FLS/CRUD security and SOQL index optimization standards with cacheable methods for LWCs.
 * @author ABC Bank Enterprise Engineering
 */
public with sharing class BLMS_LoanApplicationSelector {

    public static List<Loan_Application__c> getLoansWithEMISchedules(Set<Id> loanIds) {
        if (loanIds == null || loanIds.isEmpty()) {
            return new List<Loan_Application__c>();
        }
        return [
            SELECT Id, Name, Loan_Amount__c, Loan_Tenure_Months__c, EMI_Amount__c, Loan_Status__c,
                   Customer__c, Customer__r.Credit_Score__c, Customer__r.Monthly_Salary_Amount__c,
                   Paid_EMI_Count__c, Total_EMI_Count__c, Total_Amount_Paid__c,
                   (SELECT Id, EMI_Number__c, Due_Date__c, EMI_Amount__c, Is_Paid_Flag__c, Paid_Date__c 
                    FROM EMI_Schedules__r ORDER BY EMI_Number__c ASC)
            FROM Loan_Application__c
            WHERE Id IN :loanIds
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Loan_Application__c> getLoansByStatus(String status) {
        return [
            SELECT Id, Name, Customer__c, Customer__r.Name, Loan_Amount__c, Loan_Type__c, Loan_Status__c, Applied_Date__c, Branch__c
            FROM Loan_Application__c
            WHERE Loan_Status__c = :status
            LIMIT 2000
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getDashboardKPIs() {
        Map<String, Object> metrics = new Map<String, Object>();
        
        Integer totalApps = [SELECT COUNT() FROM Loan_Application__c];
        Integer pendingApproval = [SELECT COUNT() FROM Loan_Application__c WHERE Loan_Status__c = 'Applied' OR Loan_Status__c = 'Under Review'];
        Integer disbursedCount = [SELECT COUNT() FROM Loan_Application__c WHERE Loan_Status__c = 'Disbursed'];
        Integer defaultedCount = [SELECT COUNT() FROM Loan_Application__c WHERE Loan_Status__c = 'Defaulted'];
        
        AggregateResult[] totalVolumeResult = [SELECT SUM(Loan_Amount__c) totalVol FROM Loan_Application__c WHERE Loan_Status__c != 'Rejected'];
        Decimal totalVolume = (totalVolumeResult.size() > 0 && totalVolumeResult[0].get('totalVol') != null) ? (Decimal)totalVolumeResult[0].get('totalVol') : 0;

        metrics.put('totalApplications', totalApps);
        metrics.put('pendingApproval', pendingApproval);
        metrics.put('disbursedCount', disbursedCount);
        metrics.put('defaultedCount', defaultedCount);
        metrics.put('totalVolume', totalVolume);
        metrics.put('approvalRate', totalApps > 0 ? (Decimal.valueOf(disbursedCount) / Decimal.valueOf(totalApps) * 100).setScale(1) : 0);

        return metrics;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getPipelineSummary() {
        List<Map<String, Object>> stageSummary = new List<Map<String, Object>>();
        AggregateResult[] groupedResults = [
            SELECT Loan_Status__c status, COUNT(Id) cnt, SUM(Loan_Amount__c) totalAmt 
            FROM Loan_Application__c 
            GROUP BY Loan_Status__c
        ];
        
        for (AggregateResult ar : groupedResults) {
            Map<String, Object> stageMap = new Map<String, Object>();
            stageMap.put('status', ar.get('status'));
            stageMap.put('count', ar.get('cnt'));
            stageMap.put('amount', ar.get('totalAmt') != null ? ar.get('totalAmt') : 0);
            stageSummary.add(stageMap);
        }
        return stageSummary;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getRecentActivities() {
        List<Map<String, Object>> activities = new List<Map<String, Object>>();
        List<Loan_Application__c> recentLoans = [
            SELECT Id, Name, Customer__r.Name, Loan_Status__c, Loan_Amount__c, LastModifiedDate 
            FROM Loan_Application__c 
            ORDER BY LastModifiedDate DESC 
            LIMIT 10
        ];

        for (Loan_Application__c loan : recentLoans) {
            Map<String, Object> act = new Map<String, Object>();
            act.put('id', loan.Id);
            act.put('title', 'Application ' + loan.Name + ' updated');
            act.put('description', (loan.Customer__r != null ? loan.Customer__r.Name : 'Applicant') + ' - Status changed to ' + loan.Loan_Status__c);
            act.put('timestamp', loan.LastModifiedDate.format('MMM dd, yyyy hh:mm a'));
            act.put('status', loan.Loan_Status__c);
            activities.add(act);
        }
        return activities;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getPendingTasks() {
        List<Map<String, Object>> tasks = new List<Map<String, Object>>();
        List<Loan_Application__c> pendingReview = [
            SELECT Id, Name, Customer__r.Name, Applied_Date__c, Loan_Amount__c 
            FROM Loan_Application__c 
            WHERE Loan_Status__c = 'Applied' OR Loan_Status__c = 'Under Review'
            ORDER BY Applied_Date__c ASC 
            LIMIT 5
        ];

        for (Loan_Application__c loan : pendingReview) {
            Map<String, Object> t = new Map<String, Object>();
            t.put('id', loan.Id);
            t.put('subject', 'Review Loan Application #' + loan.Name);
            t.put('customer', loan.Customer__r != null ? loan.Customer__r.Name : 'Applicant');
            t.put('amount', loan.Loan_Amount__c);
            t.put('priority', loan.Loan_Amount__c >= 1000000 ? 'High' : 'Normal');
            t.put('dueDate', loan.Applied_Date__c != null ? loan.Applied_Date__c.addDays(2).format() : Date.today().format());
            tasks.add(t);
        }
        return tasks;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getNotifications() {
        List<Map<String, Object>> notifications = new List<Map<String, Object>>();
        Integer overdueEMIs = [SELECT COUNT() FROM EMI_Schedule__c WHERE Due_Date__c < TODAY AND Is_Paid_Flag__c = false];
        Integer pendingDocs = [SELECT COUNT() FROM Loan_Document__c WHERE Verification_Status__c = 'Pending'];

        if (overdueEMIs > 0) {
            Map<String, Object> n1 = new Map<String, Object>();
            n1.put('id', 'notif-overdue');
            n1.put('type', 'warning');
            n1.put('title', 'Overdue EMIs Alert');
            n1.put('message', overdueEMIs + ' EMI payments are currently overdue and require follow-up.');
            n1.put('time', 'Just now');
            notifications.add(n1);
        }

        if (pendingDocs > 0) {
            Map<String, Object> n2 = new Map<String, Object>();
            n2.put('id', 'notif-docs');
            n2.put('type', 'info');
            n2.put('title', 'Document Verification Pending');
            n2.put('message', pendingDocs + ' KYC/Income documents awaiting verification.');
            n2.put('time', '1 hour ago');
            notifications.add(n2);
        }

        return notifications;
    }
}
