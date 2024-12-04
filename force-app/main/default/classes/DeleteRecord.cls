global class DeleteRecord implements Database.Batchable<sObject>, Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Fetch all Student__c records to delete
        return Database.getQueryLocator('SELECT Id FROM Student__c');
    }

    Integer totalDeleted = 0;

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        try {
            // Delete the records in the current scope
            delete scope;
            totalDeleted += scope.size();
            System.debug(scope.size() + ' records deleted in this batch.');
        } catch (DmlException e) {
            System.debug('Error deleting records: ' + e.getMessage());
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Batch Job Completed Successfully.');
        
        // Send email summary
        String subject = 'Batch Job Completed: Record Deletion Summary';
        String body = 'Student account deletion has completed successfully.\n\n' +
                      totalDeleted + ' records deleted.\n\n' +
                      'Thanks';
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { 'nasrulhasan2010@gmail.com' });
        email.setSubject(subject);
        email.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}
