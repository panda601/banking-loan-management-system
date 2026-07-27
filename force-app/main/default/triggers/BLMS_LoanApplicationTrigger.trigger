/**
 * @description Apex Trigger on Loan_Application__c object for ABC Bank BLMS
 * @author ABC Bank Enterprise Engineering
 */
trigger BLMS_LoanApplicationTrigger on Loan_Application__c (before insert, before update, after update) {
    BLMS_LoanApplicationTriggerHandler handler = new BLMS_LoanApplicationTriggerHandler();

    if (Trigger.isBefore && Trigger.isInsert) {
        handler.beforeInsert(Trigger.new);
    } else if (Trigger.isBefore && Trigger.isUpdate) {
        handler.beforeUpdate(Trigger.new, Trigger.oldMap);
    } else if (Trigger.isAfter && Trigger.isUpdate) {
        handler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
}
