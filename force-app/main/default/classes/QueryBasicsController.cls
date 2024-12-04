public class QueryBasicsController {
    public static void queryData(String recordId){
        
        //list for reciving data
        List<Contact> conList = [SELECT ID, LastName FROM Contact WHERE Id =: recordId];
        
        //showing individula output
        for(Contact con: conList){
            System.debug(con.LastName);
        }
        
    }

}