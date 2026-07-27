/**
 * @description Trigger on Payment__c object
 * @author ABC Bank Enterprise Engineering
 */
trigger BLMS_PaymentTrigger on Payment__c (after insert) {
    BLMS_PaymentTriggerHandler handler = new BLMS_PaymentTriggerHandler();

    if (Trigger.isAfter && Trigger.isInsert) {
        handler.afterInsert(Trigger.new);
    }
}
