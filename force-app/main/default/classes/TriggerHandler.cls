public with sharing class TriggerHandler {

    public static void validateAccounts(List<Account> accounts) {
        for (Account acc : accounts) {
            // Check if the account meets the validation criteria.
            if (acc.Type == 'Customer - Direct' && acc.AnnualRevenue < 100000 ) {
                acc.addError('The Annual Revenue must be greater than 100,000 for Customer - Direct accounts');
            }
        }
    }
  
}




trigger AccountRevenueChangeTrigger on Account (after update) {
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

    for (Account acc : Trigger.new) {
        Account oldAcc = Trigger.oldMap.get(acc.Id);
        
        // Check if AnnualRevenue has changed significantly
        if (oldAcc.AnnualRevenue > 0) {
            Decimal changePercentage = ((acc.AnnualRevenue - oldAcc.AnnualRevenue) / oldAcc.AnnualRevenue) * 100;
            
            if (Math.abs(changePercentage) > 20) {
                // Prepare email details
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>{'admin@yourcompany.com'}); // Replace with actual email
                email.setSubject('Significant Revenue Change Detected');
                email.setPlainTextBody('Account Name: ' + acc.Name +
                    '\nPrevious Revenue: ' + oldAcc.AnnualRevenue +
                    '\nCurrent Revenue: ' + acc.AnnualRevenue +
                    '\nChange Percentage: ' + changePercentage + '%');
                
                emails.add(email);
            }
        }
    }
    
    // Send the emails
    if (!emails.isEmpty()) {
        Messaging.sendEmail(emails);
    }
}

trigger Account on Account (after update) {
   
}








