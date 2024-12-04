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
public class SimpleCalculatorTest {
    // test add method
    @isTest
    static void testAdd() {
        Test.startTest();
        SimpleCalculator calculator = new SimpleCalculator();
        
        Integer result = calculator.add(5, 3);
        System.assert(result == 8);
        Test.stopTest();
    }

     //test subtract method
    @isTest
    static void testSubtract() {
        Test.startTest();
        SimpleCalculator calculator = new SimpleCalculator();
        Integer result = calculator.subtract(10, 4);
        System.assert(result == 6);
        Test.stopTest();
    }

    //test divide method
    @isTest
    static void testDividePositive() {
        Test.startTest();
        SimpleCalculator calculator = new SimpleCalculator();
        Integer result = calculator.divide(10, 2);
        System.assert(result == 5);
        Test.stopTest();
    }

    @isTest
    static void testDivideZero() {
        Test.startTest();
        SimpleCalculator calculator = new SimpleCalculator();
       
        Integer result = Calculator.divide(10, 0);
         System.assert(result == 0, 'Divide by zero');
        Test.stopTest();
}
    }
