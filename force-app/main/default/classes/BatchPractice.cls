global class BatchPractice implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT ID, Name From Account');	

    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        for(Account acc: (List<Account>)scope){
            acc.Description = acc.Description+' - Updated';
        }
        update scope;
    }
    global void finish(Database.BatchableContext BC){
        System.debug('Job Done');
    }
}