/**
 * @description       : 
 * @author            : Nasrul Hasan
 * @group             : 
 * @last modified on  : 01-05-2025
 * @last modified by  : Nasrul Hasan
**/
public with sharing class ContactController {

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(List<Id> contactIds) {
        System.debug('contactIds: ' + contactIds);
        return [SELECT Id, Name, Email, Phone FROM Contact WHERE Id IN :contactIds];
    }

    @AuraEnabled(cacheable=true)
    public static void sendEmailToAdmin(List<Id> contactIds) {
        System.debug('contactIds: ' + contactIds);
        // Fetch contacts
        List<Contact> selectedContacts = [SELECT Name, Email, Phone FROM Contact WHERE Id IN :contactIds];
        
        System.debug(selectedContacts);
        // Generate CSV
        String csv = 'Name,Email,Phone\n';
        for (Contact contact : selectedContacts) {
            csv += contact.Name + ',' + contact.Email + ',' + contact.Phone + '\n';
        }

        //Send email
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('SelectedContacts.csv');
        attachment.setBody(Blob.valueOf(csv));
        attachment.setContentType('text/csv');

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { 'nasrulhasan2010@gmail.com' });
        email.setSubject('Selected Contacts');
        email.setPlainTextBody('Please find the selected contacts attached.');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}