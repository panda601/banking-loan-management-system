/**
 * @description Unit test for BLMS Loan Selector and Service utility methods
 * @author ABC Bank Enterprise Engineering
 */
@isTest
private class BLMS_LoanServiceTest {

    @testSetup
    static void setupServiceData() {
        Customer__c cust = BLMS_TestDataFactory.createCustomers(1)[0];
        insert cust;

        Loan_Application__c loan = BLMS_TestDataFactory.createLoanApplications(new List<Customer__c>{cust}, 500000, 24)[0];
        insert loan;
    }

    @isTest
    static void testSelectorQueries() {
        Loan_Application__c loan = [SELECT Id, Loan_Status__c FROM Loan_Application__c LIMIT 1];
        
        Test.startTest();
        List<Loan_Application__c> resultLoans = BLMS_LoanApplicationSelector.getLoansWithEMISchedules(new Set<Id>{loan.Id});
        List<Loan_Application__c> statusLoans = BLMS_LoanApplicationSelector.getLoansByStatus(loan.Loan_Status__c);
        Test.stopTest();

        System.assertEquals(1, resultLoans.size(), 'Selector should return 1 loan record');
        System.assert(statusLoans.size() >= 1, 'Selector should return loans matching status');
    }
}
