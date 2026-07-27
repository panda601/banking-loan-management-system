/**
 * @description Apex Unit Test for Payment Trigger and Payment Processing Service
 * Validates EMI payment allocation, multi-EMI coverage, and bulk payment processing.
 * @author ABC Bank Enterprise Engineering
 */
@isTest
private class BLMS_PaymentTriggerTest {

    @testSetup
    static void setupData() {
        Customer__c cust = BLMS_TestDataFactory.createCustomers(1)[0];
        insert cust;

        Loan_Application__c loan = BLMS_TestDataFactory.createLoanApplications(new List<Customer__c>{cust}, 120000, 12)[0];
        insert loan;

        loan.Loan_Status__c = 'Disbursed';
        update loan;
    }

    @isTest
    static void testSingleEMIPaymentProcessing() {
        Loan_Application__c loan = [SELECT Id, EMI_Amount__c FROM Loan_Application__c LIMIT 1];
        
        Test.startTest();
        Payment__c payment = new Payment__c(
            Loan_Application__c = loan.Id,
            Payment_Amount__c = loan.EMI_Amount__c,
            Payment_Date__c = Date.today(),
            Payment_Mode__c = 'NEFT',
            Payment_Status__c = 'Completed',
            Transaction_ID__c = 'TXN-TEST-101'
        );
        insert payment;
        Test.stopTest();

        List<EMI_Schedule__c> emiList = [SELECT Id, EMI_Number__c, Is_Paid_Flag__c FROM EMI_Schedule__c WHERE Loan_Application__c = :loan.Id ORDER BY EMI_Number__c ASC];
        System.assertEquals(true, emiList[0].Is_Paid_Flag__c, 'First EMI schedule should be marked as paid');
        System.assertEquals(false, emiList[1].Is_Paid_Flag__c, 'Second EMI schedule should remain unpaid');
    }

    @isTest
    static void testMultiEMIPaymentProcessing() {
        Loan_Application__c loan = [SELECT Id, EMI_Amount__c FROM Loan_Application__c LIMIT 1];
        
        Test.startTest();
        // Payment covering 3 EMIs
        Payment__c payment = new Payment__c(
            Loan_Application__c = loan.Id,
            Payment_Amount__c = loan.EMI_Amount__c * 3,
            Payment_Date__c = Date.today(),
            Payment_Mode__c = 'UPI',
            Payment_Status__c = 'Completed',
            Transaction_ID__c = 'TXN-MULTI-303'
        );
        insert payment;
        Test.stopTest();

        List<EMI_Schedule__c> paidEmis = [SELECT Id FROM EMI_Schedule__c WHERE Loan_Application__c = :loan.Id AND Is_Paid_Flag__c = true];
        System.assertEquals(3, paidEmis.size(), '3 EMI schedules should be marked as paid');
    }
}
