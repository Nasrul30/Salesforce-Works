trigger RevenueChangeTrigger on Account (after update) {
    // Map to store account owners' emails
    Map<Id, User> ownerEmails = new Map<Id, User>();

    // Fetch owner email for all accounts in the trigger
    Set<Id> ownerIds = new Set<Id>();
    for (Account acc : Trigger.new) {
        if (acc.OwnerId != null) {
            ownerIds.add(acc.OwnerId);
        }
    }

    // Query User object to get email addresses
    if (!ownerIds.isEmpty()) {
        for (User u : [SELECT Id, Email, Name FROM User WHERE Id IN :ownerIds]) {
            ownerEmails.put(u.Id, u);
        }
    }

    // List to store email messages
    List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();

    // Loop through updated accounts
    for (Account newAccount : Trigger.new) {
        Account oldAccount = Trigger.oldMap.get(newAccount.Id);

        // Ensure oldRevenue is not null and greater than zero
        if (oldAccount.AnnualRevenue != null && oldAccount.AnnualRevenue > 0) {
            Decimal oldRevenue = oldAccount.AnnualRevenue;
            Decimal newRevenue = newAccount.AnnualRevenue;

            // Calculate percentage change
            Decimal percentageChange = ((newRevenue - oldRevenue) / oldRevenue) * 100;

            // Check for significant increase or decrease
            if (Math.abs(percentageChange) > 20) {
                // Get the owner's email
                User accountOwner = ownerEmails.get(newAccount.OwnerId);

                if (accountOwner != null && accountOwner.Email != null) {
                    // Create email notification
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new String[] { accountOwner.Email });

                    // Check for increase or decrease
                    if (percentageChange > 0) {
                        email.setSubject('Significant Increase in Annual Revenue for Account: ' + newAccount.Name);
                        email.setPlainTextBody(
                            'Dear ' + accountOwner.Name + ',\n\n' +
                            'The annual revenue for account "' + newAccount.Name + '" has increased significantly by ' +
                            percentageChange.setScale(2) + '%. \n\n' +
                            'New revenue: ' + newRevenue + '\n' +
                            'Old revenue: ' + oldRevenue + '\n\n' +
                            'Please review this change and take necessary action.'
                        );
                    } else {
                        email.setSubject('Significant Decrease in Annual Revenue for Account: ' + newAccount.Name);
                        email.setPlainTextBody(
                            'Dear ' + accountOwner.Name + ',\n\n' +
                            'The annual revenue for account "' + newAccount.Name + '" has decreased significantly by ' +
                            Math.abs(percentageChange).setScale(2) + '%. \n\n' +
                            'New revenue: ' + newRevenue + '\n' +
                            'Old revenue: ' + oldRevenue + '\n\n' +
                            'Please review this change and take necessary action.'
                        );
                    }

                    // Add email to the list
                    emailMessages.add(email);
                }
            }
        }
    }

    // Send all emails
    if (!emailMessages.isEmpty()) {
        Messaging.sendEmail(emailMessages);
    }
}
