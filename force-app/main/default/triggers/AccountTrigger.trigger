//We can use a TriggerFramework for better control, due to time contranint going with simple trigger handler logic
trigger AccountTrigger on Account (before insert) {
    AccountTriggerHandler.beforeInsertHandler(Trigger.new);
}