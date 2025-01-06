public with sharing class CSVEmailSender {
    @AuraEnabled
    public static void sendCSVEmail(List<Id> selectedRecordIds) {
        // Fetch all accounts except those that are selected (in listView)
        List<Account> allAccounts = [SELECT Id, Name, Industry, Phone, BillingCity FROM Account];
        
        // Filter out the selected accounts
        List<Account> unselectedAccounts = new List<Account>();
        for (Account acc : allAccounts) {
            if (!selectedRecordIds.contains(acc.Id)) {
                unselectedAccounts.add(acc);
            }
        }

        // Generate CSV content for unselected accounts
        String csvContent = 'Name,Industry,Phone,Billing City\n';
        for (Account acc : unselectedAccounts) {
            csvContent += String.join(new String[] { 
                acc.Name, 
                acc.Industry != null ? acc.Industry : '', // Handle null values
                acc.Phone != null ? acc.Phone : '', 
                acc.BillingCity != null ? acc.BillingCity : '' 
            }, ',') + '\n';
        }

        // Create a CSV file attachment
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('UnselectedAccounts.csv');
        attachment.setBody(Blob.valueOf(csvContent));
        attachment.setContentType('text/csv');

        // Get the current user's email address
        String currentUserEmail = UserInfo.getUserEmail();

        // Send email with attachment to the current user
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { currentUserEmail }); // Send to current user
        email.setSubject('CSV of Unselected Accounts');
        email.setPlainTextBody('Please find the attached CSV file of unselected accounts.');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}
