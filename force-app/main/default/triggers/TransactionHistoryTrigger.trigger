//We can use a TriggerFramework for better control, due to time contranint going with simple trigger handler logic
trigger TransactionHistoryTrigger on Transaction_History__c (before insert) {
    TransactionHistoryTriggerHandler.beforeInsertHandler(Trigger.new);
}