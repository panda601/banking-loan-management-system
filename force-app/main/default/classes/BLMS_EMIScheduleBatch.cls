/**
 * @description Batch & Schedulable Apex for processing overdue EMIs and updating Loan delinquency.
 * @author ABC Bank Enterprise Engineering
 */
public with sharing class BLMS_EMIScheduleBatch implements Database.Batchable<sObject>, Schedulable, Database.Stateful {

    public Integer overdueCount = 0;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date todayDate = Date.today();
        return Database.getQueryLocator([
            SELECT Id, Due_Date__c, Is_Paid_Flag__c, Loan_Application__c
            FROM EMI_Schedule__c
            WHERE Due_Date__c < :todayDate AND Is_Paid_Flag__c = false
        ]);
    }

    public void execute(Database.BatchableContext bc, List<EMI_Schedule__c> scope) {
        Set<Id> loanIdsToDefault = new Set<Id>();
        for (EMI_Schedule__c emi : scope) {
            overdueCount++;
            if (emi.Due_Date__c < Date.today().addDays(-90)) {
                loanIdsToDefault.add(emi.Loan_Application__c);
            }
        }

        if (!loanIdsToDefault.isEmpty()) {
            List<Loan_Application__c> loansToUpdate = [
                SELECT Id, Loan_Status__c 
                FROM Loan_Application__c 
                WHERE Id IN :loanIdsToDefault 
                WITH USER_MODE
            ];
            for (Loan_Application__c loan : loansToUpdate) {
                loan.Loan_Status__c = 'Defaulted';
            }
            update as user loansToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug(LoggingLevel.INFO, 'BLMS_EMIScheduleBatch finished. Total overdue records evaluated: ' + overdueCount);
    }

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new BLMS_EMIScheduleBatch(), 200);
    }
}
