public class Task {
    
    
    public static void Task1(){
            //preparing list
            List<String> City = new List<String>();
            City.add('New York');
            City.add('Paris');
            City.add('New York');
            City.add('Berlin');
            City.add('Paris');
            City.add('Tokyo');
         //Remove duplicating from the list
            Set<string> UniqueCity = new Set<string>(City);
            System.debug('Unique cities are: '+ UniqueCity);
        //Sorting the cities name
             List<string>SortCity = new List<string>(City);
             SortCity.sort();
             System.debug('Sorting cities are: '+ SortCity);
        
        
           
     }
    
    public static void Task2(){
        
        //Map for employee id
             Map <String, Integer> EMP = new Map<String,Integer>();
        //Adding five memebers with key 
             EMP.put('Ronaldo',1);
             EMP.put('Kaka',2);
             EMP.put('Messi',3);
             EMP.put('Neymar',4);
             EMP.put('Vinicius',5);
            //  System.assertEquals(true, EMP.containsKey(1),'Key 1 is missing!');
     // Checking specific key is avaialable or not
             String empcheck = 'Ronaldo';
            // boolean result = System.assertEquals(true, EMP.containsKey(empcheck),'Key 1 is missing!');
             boolean result = EMP.containsKey(empcheck);
             System.debug(result);
        
        if (EMP.containsKey(empcheck)) {
            System.debug('Employee "' + empcheck + '" exists in the Map.');
        } else {
            System.debug('Employee "' + empcheck + '" does not exist in the Map.');
        }

            //Retrieving and print all employee id 
        Set<String> EmployeeKey = EMP.keySet();
        System.debug('Employee Id is '+ EmployeeKey);
        
        List<Integer> eid = EMP.values();
        System.debug('Employee Id is '+ eid);
        


        //Displays all keys with their name
        System.debug('Employees are:'+EMP);
        // Printing another way for
        for(String key: EMP.keySet()){
                System.debug(key + '=>' + EMP.get(key)+'\n');	
        }

        
    }

}