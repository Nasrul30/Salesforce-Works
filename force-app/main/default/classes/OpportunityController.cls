public with sharing class OpportunityController { 
    @AuraEnabled
    public static List<Opportunity> getOpportunity() {
        try {
            return [SELECT Id, Name, Amount, CloseDate FROM Opportunity LIMIT 1];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
