trigger Validation on Account (before insert, after delete) {
    if (Trigger.isBefore && Trigger.isInsert) {
        TriggerHandler.validateAccounts(Trigger.new);
    }
}


