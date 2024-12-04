public class AccountService {
    public static void updateAccountIndustry(List<Account> accounts) {
        for (Account acc : accounts) {
            if (acc.Industry == null) {
                acc.Industry = 'Unspecified';
            }
        }
        update accounts;
    }
    
    public static Boolean isAccountInIndustry(String accountId, String industry) {
        Account acc = [SELECT Industry FROM Account WHERE Id = :accountId LIMIT 1];
        return acc.Industry == industry;
    }
}
