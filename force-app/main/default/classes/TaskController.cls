public with sharing class TaskController {

    List<Account> accounts = [
            SELECT Name, Industry, Employees, 
                   (SELECT Name, StageName 
                    FROM Opportunities 
                    WHERE CreatedDate = TODAY), 
                   (SELECT CaseNumber, Status 
                    FROM Cases 
                    WHERE CreatedDate = YESTERDAY) 
            FROM Account 
            WHERE Employees > 3500
        ];
    public TaskController() {

    }
}