/**
 * @description Unit test for BLMS EMI Schedule Batch and Schedulable Apex
 * @author ABC Bank Enterprise Engineering
 */
@isTest
private class BLMS_EMIScheduleBatchTest {

    @testSetup
    static void setupBatchData() {
        Customer__c cust = BLMS_TestDataFactory.createCustomers(1)[0];
        insert cust;

        Loan_Application__c loan = BLMS_TestDataFactory.createLoanApplications(new List<Customer__c>{cust}, 200000, 12)[0];
        insert loan;

        loan.Loan_Status__c = 'Disbursed';
        update loan;

        // Force past due dates on EMI schedules to simulate overdue items
        List<EMI_Schedule__c> emis = [SELECT Id, Due_Date__c FROM EMI_Schedule__c WHERE Loan_Application__c = :loan.Id];
        for (EMI_Schedule__c emi : emis) {
            emi.Due_Date__c = Date.today().addDays(-100);
        }
        update emis;
    }

    @isTest
    static void testBatchExecution() {
        Test.startTest();
        BLMS_EMIScheduleBatch batch = new BLMS_EMIScheduleBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();

        Loan_Application__c updatedLoan = [SELECT Id, Loan_Status__c FROM Loan_Application__c LIMIT 1];
        System.assertEquals('Defaulted', updatedLoan.Loan_Status__c, 'Loan status should be updated to Defaulted due to 90+ days overdue EMIs');
    }

    @isTest
    static void testSchedulableExecution() {
        Test.startTest();
        String cronExp = '0 0 0 1 1 ? 2030';
        String jobId = System.schedule('TestBLMSEMIScheduleBatch', cronExp, new BLMS_EMIScheduleBatch());
        Test.stopTest();

        System.assertNotEquals(null, jobId, 'Job ID should be returned from System.schedule');
    }
}
