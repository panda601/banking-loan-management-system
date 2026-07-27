/**
 * @description Enterprise Test Data Factory for Banking Loan Management System (BLMS)
 * Follows Salesforce Well-Architected Framework and SeeAllData=false compliance.
 * Supports bulk generation of Customers, Loans, Guarantors, Documents, EMI Schedules, and Payments.
 * @author ABC Bank Enterprise Engineering
 */
@isTest
public class BLMS_TestDataFactory {

    public static Id getLegacyStudentAppId() {
        if (Schema.getGlobalDescribe().containsKey('Student_Application__c')) {
            List<SObject> apps = Database.query('SELECT Id FROM Student_Application__c LIMIT 1');
            if (!apps.isEmpty()) {
                return apps[0].Id;
            } else if (Schema.getGlobalDescribe().containsKey('Course__c')) {
                List<SObject> courses = Database.query('SELECT Id FROM Course__c LIMIT 1');
                Id courseId = null;
                if (!courses.isEmpty()) {
                    courseId = courses[0].Id;
                } else {
                    SObject c = (SObject) Type.forName('Course__c').newInstance();
                    c.put('Name', 'Computer Science');
                    insert c;
                    courseId = c.Id;
                }
                SObject stdApp = (SObject) Type.forName('Student_Application__c').newInstance();
                stdApp.put('First_Name__c', 'Test');
                stdApp.put('Last_Name__c', 'Student');
                stdApp.put('Email__c', 'test' + System.currentTimeMillis() + '@student.com');
                stdApp.put('Date_Of_Birth__c', Date.today().addYears(-20));
                stdApp.put('Applied_Course__c', courseId);
                insert stdApp;
                return stdApp.Id;
            }
        }
        return null;
    }

    /**
     * @description Creates test Users with specified Profile and User Role
     */
    public static User createTestUser(String profileName, String lastName, String alias) {
        Profile p = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1];
        String uniqueName = alias + System.currentTimeMillis() + '@abcbank.com';
        User u = new User(
            FirstName = 'Test',
            LastName = lastName,
            Email = uniqueName,
            Username = uniqueName,
            Alias = alias.substring(0, Math.min(alias.length(), 8)),
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id
        );
        insert u;
        return u;
    }

    /**
     * @description Generates list of Customer__c records
     */
    public static List<Customer__c> createCustomers(Integer count) {
        List<Customer__c> customers = new List<Customer__c>();
        for (Integer i = 0; i < count; i++) {
            customers.add(new Customer__c(
                Customer_External_ID__c = 'CUST-' + String.valueOf(10000 + i),
                Mobile_Phone__c = '98765' + String.valueOf(10000 + i),
                Email_Address__c = 'customer' + i + '_' + System.currentTimeMillis() + '@abcbank.com',
                Aadhaar_Code__c = '1234' + String.valueOf(10000000 + i),
                PAN_Code__c = 'ABCDE' + String.valueOf(1000 + (Math.mod(i, 8000))) + 'F',
                Credit_Score__c = 650 + Math.mod(i, 200),
                Monthly_Salary_Amount__c = 50000 + (i * 100),
                Employment_Type__c = (Math.mod(i, 2) == 0) ? 'Salaried' : 'Self-Employed',
                Date_Of_Birth__c = Date.today().addYears(-30)
            ));
        }
        return customers;
    }

    /**
     * @description Generates Loan_Application__c records for a Customer list
     */
    public static List<Loan_Application__c> createLoanApplications(List<Customer__c> customers, Decimal amount, Integer tenureMonths) {
        List<Loan_Application__c> loans = new List<Loan_Application__c>();
        for (Integer i = 0; i < customers.size(); i++) {
            loans.add(new Loan_Application__c(
                Customer__c = customers[i].Id,
                Loan_Type__c = (Math.mod(i, 3) == 0) ? 'Personal Loan' : (Math.mod(i, 3) == 1 ? 'Home Loan' : 'Auto Loan'),
                Loan_Amount__c = amount,
                Loan_Tenure_Months__c = tenureMonths,
                Interest_Rate_Percent__c = 10.5,
                Loan_Status__c = 'Draft',
                Applied_Date__c = Date.today(),
                Branch__c = 'Downtown Branch'
            ));
        }
        return loans;
    }

    /**
     * @description Generates EMI_Schedule__c records for a Loan
     */
    public static List<EMI_Schedule__c> createEMISchedules(Id loanId, Integer tenureMonths, Decimal emiAmount) {
        List<EMI_Schedule__c> schedules = new List<EMI_Schedule__c>();
        Decimal totalPrincipal = emiAmount * 0.8;
        Decimal totalInterest = emiAmount * 0.2;
        Date startDate = Date.today().addMonths(1);

        for (Integer i = 1; i <= tenureMonths; i++) {
            schedules.add(new EMI_Schedule__c(
                Loan_Application__c = loanId,
                EMI_Number__c = i,
                Due_Date__c = startDate.addMonths(i - 1),
                EMI_Amount__c = emiAmount,
                Principal_Amount__c = totalPrincipal,
                Interest_Amount__c = totalInterest,
                Outstanding_Balance_Amount__c = emiAmount * (tenureMonths - i + 1),
                Is_Paid_Flag__c = false
            ));
        }
        return schedules;
    }

    /**
     * @description Generates Payment__c records for a Loan Application
     */
    public static List<Payment__c> createPayments(Id loanId, Decimal paymentAmount, Integer count) {
        List<Payment__c> payments = new List<Payment__c>();
        Id legacyAppId = getLegacyStudentAppId();

        for (Integer i = 0; i < count; i++) {
            Payment__c p = new Payment__c(
                Loan_Application__c = loanId,
                Payment_Amount__c = paymentAmount,
                Payment_Date__c = Date.today(),
                Payment_Mode__c = 'NEFT',
                Payment_Status__c = 'Completed',
                Transaction_ID__c = 'TXN-' + System.currentTimeMillis() + '-' + i
            );
            if (legacyAppId != null) {
                p.put('Student_Application__c', legacyAppId);
            }
            payments.add(p);
        }
        return payments;
    }

    /**
     * @description Generates Loan_Document__c records for a Loan Application
     */
    public static List<Loan_Document__c> createLoanDocuments(Id loanId, List<String> docTypes) {
        List<Loan_Document__c> docs = new List<Loan_Document__c>();
        for (String dType : docTypes) {
            docs.add(new Loan_Document__c(
                Loan_Application__c = loanId,
                Document_Type__c = dType,
                Verification_Status__c = 'Verified',
                Upload_Date__c = Date.today()
            ));
        }
        return docs;
    }
}
