public with sharing class AccountCrontroller {

        @AuraEnabled
        public static Id saveRecord(String name, String phone, String industry) {
            if (String.isBlank(name) || String.isBlank(phone)) {
                throw new AuraHandledException('Name and Phone are required.');
            }
    
            if (!Pattern.matches('\\d{10}', phone)) {
                throw new AuraHandledException('Phone must be exactly 10 digits.');
            }
    
            // Create the record
            Account acc = new Account();
            acc.Name = name;
            acc.Phone = phone;
            acc.Industry = industry;
    
            insert acc;
            return acc.Id;
        }
    
    
}