trigger CountryCodeTrigger on Contact (before insert, before update) {
    if (Trigger.isinsert){
        for(Contact con : Trigger.new){
            String nm = con.Country_Code__c.split('- ').get(1);
            con.phone = nm+ con.phone;
        }
    }

    /*
 
    Map<String, String> countryCodeMap = new Map<String, String>{
        'Australia - (+61)' => '61',
        'Japan - +81' => '81',
        'China - +86' => '86',
        'Bangladesh - +880' => '880',
        'Spain - +34' => '34'
    };

    for (Contact con : Trigger.new) {
        //con.Country_Code__c;
        //String newCountryCode = countryCodeMap.get(con.Country_Code__c);  
        
        if (Trigger.isUpdate) {
            
            Contact oldCon = Trigger.oldMap.get(con.Id);
            String oldCountryCode = countryCodeMap.get(oldCon.Country_Code__c);
            if (!String.isBlank(oldCountryCode) && !String.isBlank(con.Phone) && con.Phone.startsWith(oldCountryCode)) {
                con.Phone = con.Phone.removeStart(oldCountryCode).trim();
            }
        }


        // create new country code if the old one is blank
        if (!String.isBlank(newCountryCode)) {
            if (String.isBlank(con.Phone)) {
                con.Phone = newCountryCode;
            } else if (!con.Phone.startsWith(newCountryCode)) {
                con.Phone = newCountryCode + con.Phone.trim();
            }
        }
    }*/
}
