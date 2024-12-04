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
private class TaskUtilTests {

    // Test case to validate 'Normal' priority for non-'CA' state
    @isTest
    static void testGetTaskPriorityNormal() {
        // This is a valid test case for a non-'CA' state (e.g., 'NY')
        Test.startTest();
        String result = TaskUtil.getTaskPriority('NY');
        System.assertEquals('Normal', result, 'Task priority for non-CA state should be Normal.');
        Test.stopTest();
    }

    // Test case to validate 'High' priority for 'CA' state
    @isTest
    static void testGetTaskPriorityHigh() {
        // This test case specifically checks if 'CA' returns 'High'
        Test.startTest();
        String result = TaskUtil.getTaskPriority('CA');
        System.assertEquals('High', result, 'Task priority for CA state should be High.');
        Test.stopTest();
    }

    // Test case for blank input (empty state)
    @isTest
    static void testGetTaskPriorityBlank() {
        // Blank state should return null
        Test.startTest();
        String result = TaskUtil.getTaskPriority('');
        System.assertEquals(null, result, 'Task priority for blank state should return null.');
        Test.stopTest();
    }

    // Test case for invalid state length (more than 2 characters)
    @isTest
    static void testGetTaskPriorityInvalidLength() {
        // Invalid length (more than 2 characters) should return null
        Test.startTest();
        String result = TaskUtil.getTaskPriority('CAL');
        System.assertEquals(null, result, 'Task priority for state with more than 2 characters should return null.');
        Test.stopTest();
    }

    // Test case for null value (invalid state)
    @isTest
    static void testGetTaskPriorityNullState() {
        // Null input should return null
        Test.startTest();
        String result = TaskUtil.getTaskPriority(null);
        System.assertEquals(null, result, 'Task priority for null state should return null.');
        Test.stopTest();
    }
}
