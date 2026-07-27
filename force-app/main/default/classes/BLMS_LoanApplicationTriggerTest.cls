/**
 * @description Enterprise Apex Unit Test for BLMS Loan Application Trigger & Handler
 * Validates SeeAllData=false, bulk creation (200 records), credit score validation rules,
 * EMI calculations, status transitions, and exception handling.
 * @author ABC Bank Enterprise Engineering
 */
@isTest
private class BLMS_LoanApplicationTriggerTest {

    @testSetup
    static void setupTestData() {
        List<Customer__c> customers = BLMS_TestDataFactory.createCustomers(200);
        insert customers;
    }

    @isTest
    static void testBulkLoanApplicationCreationAndEMICalculation() {
        List<Customer__c> customers = [SELECT Id, Credit_Score__c FROM Customer__c];
        System.assertEquals(200, customers.size(), 'Should have inserted 200 customers');

        Test.startTest();
        List<Loan_Application__c> loans = BLMS_TestDataFactory.createLoanApplications(customers, 500000, 24);
        insert loans;
        Test.stopTest();

        List<Loan_Application__c> insertedLoans = [SELECT Id, EMI_Amount__c, Eligibility_Status__c FROM Loan_Application__c];
        System.assertEquals(200, insertedLoans.size(), 'All 200 loan applications should be created successfully');
        System.assertNotEquals(null, insertedLoans[0].EMI_Amount__c, 'EMI Amount should be pre-calculated');
        System.assert(insertedLoans[0].EMI_Amount__c > 0, 'EMI Amount must be greater than zero');
    }

    @isTest
    static void testLowCreditScoreRejection() {
        Customer__c lowCreditCust = new Customer__c(
            Customer_External_ID__c = 'CUST-LOW',
            Mobile_Phone__c = '9876500000',
            Email_Address__c = 'lowcredit@abcbank.com',
            Aadhaar_Code__c = '999988887777',
            PAN_Code__c = 'LOWCR1234F',
            Credit_Score__c = 550,
            Monthly_Salary_Amount__c = 40000,
            Employment_Type__c = 'Salaried',
            Date_Of_Birth__c = Date.today().addYears(-30)
        );
        insert lowCreditCust;

        Loan_Application__c loan = new Loan_Application__c(
            Customer__c = lowCreditCust.Id,
            Loan_Type__c = 'Personal Loan',
            Loan_Amount__c = 100000,
            Loan_Tenure_Months__c = 12,
            Interest_Rate_Percent__c = 12.0
        );

        Test.startTest();
        try {
            insert loan;
            System.assert(false, 'Exception should have been thrown for credit score < 600');
        } catch (DmlException ex) {
            System.assert(ex.getMessage().contains('rejected'), 'Error message should indicate credit rejection');
        }
        Test.stopTest();
    }

    @isTest
    static void testEMIScheduleGenerationOnDisbursal() {
        Customer__c cust = [SELECT Id FROM Customer__c LIMIT 1];
        Loan_Application__c loan = BLMS_TestDataFactory.createLoanApplications(new List<Customer__c>{cust}, 300000, 12)[0];
        insert loan;

        Test.startTest();
        loan.Loan_Status__c = 'Disbursed';
        update loan;
        Test.stopTest();

        List<EMI_Schedule__c> emiList = [SELECT Id, EMI_Number__c, Is_Paid_Flag__c FROM EMI_Schedule__c WHERE Loan_Application__c = :loan.Id];
        System.assertEquals(12, emiList.size(), '12 monthly EMI schedules should be generated on loan disbursal');
        System.assertEquals(false, emiList[0].Is_Paid_Flag__c, 'EMI schedule should initially be unpaid');
    }
}
