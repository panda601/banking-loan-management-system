/**
 * @description Enterprise Service Layer for Loan Application Processing
 * Implements business validation, automated EMI calculations, and credit checks.
 * @author ABC Bank Enterprise Engineering
 */
public with sharing class BLMS_LoanApplicationService {

    public static void calculateMonthlyEMI(List<Loan_Application__c> loanList) {
        for (Loan_Application__c loan : loanList) {
            if (loan.Loan_Amount__c != null && loan.Loan_Tenure_Months__c != null && loan.Loan_Tenure_Months__c > 0) {
                Decimal annualRate = loan.Interest_Rate_Percent__c != null ? loan.Interest_Rate_Percent__c : 10.5;
                Decimal monthlyRate = annualRate / 12 / 100;
                Decimal n = loan.Loan_Tenure_Months__c;
                
                // EMI Formula: [P x R x (1+R)^N]/[(1+R)^N-1]
                Double rateFactor = Math.pow((1 + monthlyRate).doubleValue(), n.doubleValue());
                Decimal emi = (loan.Loan_Amount__c * monthlyRate * Decimal.valueOf(rateFactor)) / (Decimal.valueOf(rateFactor) - 1);
                loan.EMI_Amount__c = emi.setScale(2, RoundingMode.HALF_UP);
            }
        }
    }

    public static void validateCreditEligibility(List<Loan_Application__c> loanList, Map<Id, Customer__c> customerMap) {
        for (Loan_Application__c loan : loanList) {
            if (loan.Customer__c != null && customerMap.containsKey(loan.Customer__c)) {
                Customer__c cust = customerMap.get(loan.Customer__c);
                if (cust.Credit_Score__c != null && cust.Credit_Score__c < 600) {
                    loan.Eligibility_Status__c = 'Rejected';
                    loan.addError('Loan application rejected: Customer credit score (' + cust.Credit_Score__c + ') is below the required threshold of 600.');
                } else if (cust.Credit_Score__c != null && cust.Credit_Score__c >= 750) {
                    loan.Eligibility_Status__c = 'Pre-Approved';
                } else {
                    loan.Eligibility_Status__c = 'Eligible';
                }
            }
        }
    }

    public static void generateEMISchedulesOnDisbursal(List<Loan_Application__c> newLoans, Map<Id, Loan_Application__c> oldMap) {
        List<EMI_Schedule__c> emiListToInsert = new List<EMI_Schedule__c>();
        
        for (Loan_Application__c loan : newLoans) {
            Boolean statusChangedToDisbursed = loan.Loan_Status__c == 'Disbursed' && 
                (oldMap == null || oldMap.get(loan.Id).Loan_Status__c != 'Disbursed');

            if (statusChangedToDisbursed && loan.Loan_Tenure_Months__c != null && loan.EMI_Amount__c != null) {
                Integer tenure = loan.Loan_Tenure_Months__c.intValue();
                Decimal emiVal = loan.EMI_Amount__c;
                Date firstDueDate = Date.today().addMonths(1);

                for (Integer i = 1; i <= tenure; i++) {
                    emiListToInsert.add(new EMI_Schedule__c(
                        Loan_Application__c = loan.Id,
                        EMI_Number__c = i,
                        Due_Date__c = firstDueDate.addMonths(i - 1),
                        EMI_Amount__c = emiVal,
                        Principal_Amount__c = (emiVal * 0.75).setScale(2, RoundingMode.HALF_UP),
                        Interest_Amount__c = (emiVal * 0.25).setScale(2, RoundingMode.HALF_UP),
                        Outstanding_Balance_Amount__c = (emiVal * (tenure - i + 1)).setScale(2, RoundingMode.HALF_UP),
                        Is_Paid_Flag__c = false
                    ));
                }
            }
        }

        if (!emiListToInsert.isEmpty()) {
            insert as user emiListToInsert;
        }
    }
}
