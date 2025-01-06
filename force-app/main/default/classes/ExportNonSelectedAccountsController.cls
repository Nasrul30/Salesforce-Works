public with sharing class ExportNonSelectedAccountsController {

    @AuraEnabled
    public static void exportNonSelectedAccounts(List<Id> selectedAccountIds) {
        try {
            // Fetch non-selected accounts
            List<Account> nonSelectedAccounts = [
                SELECT Name, Industry, Phone, BillingCity
                FROM Account
                WHERE Id NOT IN :selectedAccountIds 
            ];

            // Generate CSV
            String csvContent = 'Name,Industry,Phone,Billing City\n';
            for (Account acc : nonSelectedAccounts) {
                csvContent += String.format('{0},{1},{2},{3}\n',
                    new String[] { acc.Name, acc.Industry, acc.Phone, acc.BillingCity });
            }

            // Create email attachment
            String fileName = 'NonSelectedAccounts_' + Datetime.now().format('yyyyMMdd_HHmmss') + '.csv';
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName(fileName);
            attachment.setBody(Blob.valueOf(csvContent));
            attachment.setContentType('text/csv');

            // Send email to current user
            User currentUser = [SELECT Email FROM User WHERE Id = :UserInfo.getUserId()];
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{ currentUser.Email });
            email.setSubject('Exported Non-Selected Accounts');
            email.setPlainTextBody('The CSV file containing the non-selected Accounts is attached.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ attachment });

            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
        } catch (Exception ex) {
            System.debug('Error in exportNonSelectedAccounts: ' + ex.getMessage());
            throw new AuraHandledException('An error occurred while exporting non-selected accounts.');
        }
    }
}


public with sharing class CSVEmailSender {
    @AuraEnabled
    public static void sendCSVEmail(List<Id> selectedRecordIds) {
        // Fetch all accounts except those that are selected (in listView)
        List<Account> allAccounts = [SELECT Id, Name, AnnualRevenue, Phone FROM Account];
        
        // Filter out the selected accounts
        List<Account> unselectedAccounts = new List<Account>();
        for (Account acc : allAccounts) {
            if (!selectedRecordIds.contains(acc.Id)) {
                unselectedAccounts.add(acc);
            }
        }

        // Generate CSV content for unselected accounts
        String csvContent = 'Name,Annual Revenue,Phone\n';
        for (Account acc : unselectedAccounts) {
            csvContent += String.join(new String[] { acc.Name, String.valueOf(acc.AnnualRevenue), acc.Phone }, ',') + '\n';
        }

        // Create a CSV file attachment
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('UnselectedAccounts.csv');
        attachment.setBody(Blob.valueOf(csvContent));
        attachment.setContentType('text/csv');

        // Send email with attachment
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { 'akash.saha.diu@gmail.com' }); // Replace with actual email
        email.setSubject('CSV of Unselected Accounts');
        email.setPlainTextBody('Please find the attached CSV file of unselected accounts.');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}
