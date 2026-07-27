/**
 * @description Enterprise Selector Layer for Loan Applications & Related Objects
 * Adheres to FLS/CRUD security and SOQL index optimization standards.
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
            WITH USER_MODE
        ];
    }

    public static List<Loan_Application__c> getLoansByStatus(String status) {
        return [
            SELECT Id, Name, Customer__c, Loan_Amount__c, Loan_Type__c, Loan_Status__c, Applied_Date__c
            FROM Loan_Application__c
            WHERE Loan_Status__c = :status
            WITH USER_MODE
            LIMIT 2000
        ];
    }
}
