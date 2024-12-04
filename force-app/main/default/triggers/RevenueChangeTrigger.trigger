trigger RevenueChangeTrigger on Account (after update) {

    Map<Id, User> ownerEmails = new Map<Id, User>();

    Set<Id> ownerIds = new Set<Id>();
    for (Account acc : Trigger.newMap.values()) {
        if (acc.OwnerId != null) {
            ownerIds.add(acc.OwnerId);
        }
    }

    if (!ownerIds.isEmpty()) {
        for (User u : [SELECT Id, Email, Name FROM User WHERE Id IN :ownerIds]) {
            ownerEmails.put(u.Id, u);
        }
    }

    List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();

    for (Id accId : Trigger.newMap.keySet()) {
        Account newAccount = Trigger.newMap.get(accId);
        Account oldAccount = Trigger.oldMap.get(accId);

        if (oldAccount.AnnualRevenue != null && oldAccount.AnnualRevenue > 0) {
            Decimal oldRevenue = oldAccount.AnnualRevenue;
            Decimal newRevenue = newAccount.AnnualRevenue;

            Decimal percentageChange = ((newRevenue - oldRevenue) / oldRevenue) * 100;

            if (Math.abs(percentageChange) > 20) {
                
                User accountOwner = ownerEmails.get(newAccount.OwnerId);

                if (accountOwner != null && accountOwner.Email != null) {
                    
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new String[] { accountOwner.Email }); // Set the owner's email

                    // Check for increase or decrease
                    if (percentageChange > 0) {
                        email.setSubject('Significant Increase in Annual Revenue for Account: ' + newAccount.Name);
                        email.setPlainTextBody(
                            'Dear ' + accountOwner.Name + ',\n\n' +
                            'The annual revenue for account "' + newAccount.Name + '" has increased significantly by ' +
                            percentageChange.setScale(2) + '%. \n\n' +
                            'New revenue: ' + newRevenue + '\n' +
                            'Old revenue: ' + oldRevenue + '\n\n' 
                            
                        );
                    } else {
                        email.setSubject('Significant Decrease in Annual Revenue for Account: ' + newAccount.Name);
                        email.setPlainTextBody(
                            'Dear ' + accountOwner.Name + ',\n\n' +
                            'The annual revenue for account "' + newAccount.Name + '" has decreased significantly by ' +
                            Math.abs(percentageChange).setScale(2) + '%. \n\n' +
                            'New revenue: ' + newRevenue + '\n' +
                            'Old revenue: ' + oldRevenue + '\n\n' 
                            
                        );
                    }

                    
                    emailMessages.add(email);
                }
            }
        }
    }
    if (!emailMessages.isEmpty()) {
        Messaging.sendEmail(emailMessages);
    }
}
