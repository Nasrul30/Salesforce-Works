@isTest
private class BonusClassTest {

    // Positive test case: Manager with salary > 100000 (should get 20% bonus)
    @isTest
    static void testGetBonusManagerHighSalary() {
        String bonus = BonusClass.getBonus('Manager', 150000.00); // Pass salary as Double
        System.assertEquals('20%', bonus, 'Manager with salary > 100000 should get 20% bonus.');
    }

    // Positive test case: Manager with salary <= 100000 (should get 10% bonus)
    @isTest
    static void testGetBonusManagerLowSalary() {
        String bonus = BonusClass.getBonus('Manager', 80000.00); // Pass salary as Double
        System.assertEquals('10%', bonus, 'Manager with salary <= 100000 should get 10% bonus.');
    }

    // Positive test case: Staff (should get 5% bonus)
    @isTest
    static void testGetBonusStaff() {
        String bonus = BonusClass.getBonus('Staff', 50000.00); // Pass salary as Double
        System.assertEquals('5%', bonus, 'Staff should get 5% bonus.');
    }

    // Negative test case: Non-registered role (should get no bonus)
    @isTest
    static void testGetBonusNonRegisteredRole() {
        String bonus = BonusClass.getBonus('Guest', 50000.00); // Pass salary as Double
        System.assertEquals('No bonus for other roles', bonus, 'Non-registered role should get no bonus.');
    }

    // Negative test case: Invalid role (should throw IllegalArgumentException)
    @isTest
    static void testGetBonusInvalidRole() {
        try {
            BonusClass.getBonus('', 50000.00); // Pass salary as Double
            System.assert(false, 'Expected IllegalArgumentException for empty role.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Invalid inputs', e.getMessage(), 'Should throw IllegalArgumentException for invalid role.');
        }
    }

    // Negative test case: Invalid salary (<= 0, should throw IllegalArgumentException)
    @isTest
    static void testGetBonusInvalidSalary() {
        try {
            BonusClass.getBonus('Manager', -50000.00); // Pass salary as Double
            System.assert(false, 'Expected IllegalArgumentException for negative salary.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Invalid inputs', e.getMessage(), 'Should throw IllegalArgumentException for negative salary.');
        }
    }
}
