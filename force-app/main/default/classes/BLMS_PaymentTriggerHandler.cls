/**
 * @description Payment Trigger Handler for BLMS
 * @author ABC Bank Enterprise Engineering
 */
public with sharing class BLMS_PaymentTriggerHandler {

    public void afterInsert(List<Payment__c> newPayments) {
        BLMS_PaymentService.processIncomingPayments(newPayments);
    }
}
