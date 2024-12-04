global class BatchInsert implements Database.Batchable<sObject>, Database.Stateful {
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id FROM User LIMIT 1'); 
    }

    Integer totalInserted=0;
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Student__c> records = new List<Student__c>();
  
        for (Integer i = 1; i <= 500; i++) {
            Student__c obj = new Student__c();
            obj.Name = 'Value ' + i;  
            obj.Father_s_Name__c = 'Father'+i;            
            records.add(obj);
        }
        
        
        try {
            insert records;
            totalInserted += records.size();
            System.debug(records.size() + ' records inserted in this batch.');
        } catch (DmlException e) {
            System.debug('Error inserting records: ' + e.getMessage());
        }
        
    
    }
    
 
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch Job Completed Successfully.');
          String subject = 'Batch Job Completed: Record Insertion Summary';
          String body = 'Student account has completed successfully.\n\n'+
                       totalInserted+' records inserted.\n\n'+
                       'Thanks';
          Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
          email.setToAddresses(new String[] { 'nasrulhasan2010@gmail.com' });
          email.setSubject(subject);
          email.setPlainTextBody(body);
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}

