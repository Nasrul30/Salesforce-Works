public with sharing class BonusClass {
    
    // Method to calculate bonus based on employee role and salary
    public static String getBonus(String employeeRole, Integer salary) {
        if (String.isBlank(employeeRole) || salary <= 0) {
            throw new IllegalArgumentException('Invalid inputs');
        }
        
        String bonus = 'No bonus'; // Default bonus

        // Branching logic to check employee role and apply bonus
        if (employeeRole == 'Manager') {
            if (salary > 100000) {
                bonus = '20%';
            } else {
                bonus = '10%';
            }
        } else if (employeeRole == 'Staff') {
            bonus = '5%';
        } else {
            bonus = 'No bonus for other roles';
        }

        return bonus;
    }
}
