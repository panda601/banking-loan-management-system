/**
 * @description Enterprise Trigger Handler for Loan Application object
 * Follows separation of concerns, bulkification, and exception handling standards.
 * @author ABC Bank Enterprise Engineering
 */
public with sharing class BLMS_LoanApplicationTriggerHandler {

    public void beforeInsert(List<Loan_Application__c> newLoans) {
        Set<Id> customerIds = new Set<Id>();
        for (Loan_Application__c loan : newLoans) {
            if (loan.Customer__c != null) {
                customerIds.add(loan.Customer__c);
            }
        }

        Map<Id, Customer__c> customerMap = new Map<Id, Customer__c>([
            SELECT Id, Credit_Score__c, Monthly_Salary_Amount__c 
            FROM Customer__c 
            WHERE Id IN :customerIds 
            WITH USER_MODE
        ]);

        BLMS_LoanApplicationService.calculateMonthlyEMI(newLoans);
        BLMS_LoanApplicationService.validateCreditEligibility(newLoans, customerMap);
    }

    public void beforeUpdate(List<Loan_Application__c> newLoans, Map<Id, Loan_Application__c> oldMap) {
        BLMS_LoanApplicationService.calculateMonthlyEMI(newLoans);
    }

    public void afterUpdate(List<Loan_Application__c> newLoans, Map<Id, Loan_Application__c> oldMap) {
        BLMS_LoanApplicationService.generateEMISchedulesOnDisbursal(newLoans, oldMap);
    }
}
