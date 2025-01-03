public with sharing class AccountCrontroller {
    @AuraEnabled
    public static Id saveRecord(String name, String phone, String industry) {
        if (String.isBlank(name) || String.isBlank(phone) || String.isBlank(industry)) {
            throw new AuraHandledException('Name, Phone, and Industry are required.');
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

    @AuraEnabled
    public static List<PicklistWrapper> getIndustryPicklistValues() {
        List<PicklistWrapper> options = new List<PicklistWrapper>();
        Schema.DescribeFieldResult fieldResult = Account.Industry.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry entry : picklistValues) {
            options.add(new PicklistWrapper(entry.getValue(), entry.getLabel()));
        }
        return options;
    }

    public class PicklistWrapper {
        @AuraEnabled public String value { get; set; }
        @AuraEnabled public String label { get; set; }
        
        public PicklistWrapper(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }
}
