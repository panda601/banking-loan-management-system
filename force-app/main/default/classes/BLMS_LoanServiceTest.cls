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

        loan.Loan_Status__c = 'Disbursed';
        update loan;

        BLMS_TestDataFactory.createPayments(loan.Id, 10000, 1);
    }

    @isTest
    static void testSelectorQueries() {
        Loan_Application__c loan = [SELECT Id, Loan_Status__c FROM Loan_Application__c LIMIT 1];
        
        Test.startTest();
        List<Loan_Application__c> resultLoans = BLMS_LoanApplicationSelector.getLoansWithEMISchedules(new Set<Id>{loan.Id});
        List<Loan_Application__c> statusLoans = BLMS_LoanApplicationSelector.getLoansByStatus(loan.Loan_Status__c);
        Map<String, Object> kpis = BLMS_LoanApplicationSelector.getDashboardKPIs();
        List<Map<String, Object>> pipeline = BLMS_LoanApplicationSelector.getPipelineSummary();
        List<Map<String, Object>> activities = BLMS_LoanApplicationSelector.getRecentActivities();
        List<Map<String, Object>> tasks = BLMS_LoanApplicationSelector.getPendingTasks();
        List<Map<String, Object>> notifs = BLMS_LoanApplicationSelector.getNotifications();
        Test.stopTest();

        System.assertEquals(1, resultLoans.size(), 'Selector should return 1 loan record');
        System.assert(statusLoans.size() >= 1, 'Selector should return loans matching status');
        System.assertNotEquals(null, kpis, 'KPIs map should not be null');
        System.assertNotEquals(null, pipeline, 'Pipeline summary should not be null');
        System.assertNotEquals(null, activities, 'Activities list should not be null');
        System.assertNotEquals(null, tasks, 'Tasks list should not be null');
        System.assertNotEquals(null, notifs, 'Notifications list should not be null');
    }
}
