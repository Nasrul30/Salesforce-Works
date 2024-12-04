/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AccountServiceTest {

    // Shared test data setup
    @TestSetup
    static void setupTestData() {
        insert new Account(Name = 'Account X', Industry = 'Technology');
    }

    // Unit test for updating industry
    @isTest
    static void testUpdateAccountIndustry() {
        List<Account> accounts = [SELECT Id, Industry FROM Account];
        
        Test.startTest();
        AccountService.updateAccountIndustry(accounts);
        Test.stopTest();

        Account updatedAcc = [SELECT Industry FROM Account];
        System.assertEquals('Unspecified', updatedAcc.Industry, 'Industry should be updated to Unspecified.');
    }

    // Unit test for checking account industry
    @isTest
    static void testIsAccountInIndustry() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Boolean isInIndustry = AccountService.isAccountInIndustry(acc.Id, 'Technology');

        System.assertEquals(true, isInIndustry, 'Account should belong to the Technology industry.');
    }

    // Mock callout test example
    @isTest
    static void testMockCallout() {
        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock());
        
        Test.startTest();
        HttpResponse response = CustomCalloutClass.makeCallout();
        Test.stopTest();

        System.assertEquals(200, response.getStatusCode(), 'HTTP status code should be 200.');
    }
}
