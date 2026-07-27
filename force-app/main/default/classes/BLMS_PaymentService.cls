/**
 * @description Payment Processing Service Layer for BLMS
 * Handles EMI payment allocation, overpayment adjustments, and Loan Status updates.
 * @author ABC Bank Enterprise Engineering
 */
public with sharing class BLMS_PaymentService {

    public static void processIncomingPayments(List<Payment__c> newPayments) {
        Set<Id> loanIds = new Set<Id>();
        for (Payment__c p : newPayments) {
            if (p.Payment_Status__c == 'Completed' && p.Loan_Application__c != null) {
                loanIds.add(p.Loan_Application__c);
            }
        }

        if (loanIds.isEmpty()) {
            return;
        }

        Map<Id, Loan_Application__c> loanMap = new Map<Id, Loan_Application__c>([
            SELECT Id, Loan_Status__c, Total_Amount_Paid__c,
                   (SELECT Id, EMI_Number__c, EMI_Amount__c, Is_Paid_Flag__c, Paid_Date__c 
                    FROM EMI_Schedules__r 
                    WHERE Is_Paid_Flag__c = false 
                    ORDER BY EMI_Number__c ASC)
            FROM Loan_Application__c
            WHERE Id IN :loanIds
        ]);

        List<EMI_Schedule__c> emiToUpdate = new List<EMI_Schedule__c>();

        for (Payment__c p : newPayments) {
            if (p.Payment_Status__c == 'Completed' && loanMap.containsKey(p.Loan_Application__c)) {
                Loan_Application__c loan = loanMap.get(p.Loan_Application__c);
                Decimal remainingPayment = p.Payment_Amount__c;

                for (EMI_Schedule__c emi : loan.EMI_Schedules__r) {
                    if (remainingPayment <= 0) break;

                    if (remainingPayment >= emi.EMI_Amount__c) {
                        emi.Is_Paid_Flag__c = true;
                        emi.Paid_Date__c = p.Payment_Date__c != null ? p.Payment_Date__c : Date.today();
                        remainingPayment -= emi.EMI_Amount__c;
                        emiToUpdate.add(emi);
                    }
                }
            }
        }

        if (!emiToUpdate.isEmpty()) {
            update emiToUpdate;
        }
    }
}
