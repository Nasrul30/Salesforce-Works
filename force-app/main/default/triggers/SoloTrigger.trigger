trigger SoloTrigger on Account (after insert) {

        List<Contact> Ins = new List<Contact>();
        for(Account acc: trigger.new){
            Contact newContact = new Contact(
                FirstName = 'Default',
                LastName = acc.Name +'Contact',
                AccountId = acc.Id
                
            );

            Ins.add(newContact);
        }

        if(!Ins.isEmpty()){
            insert Ins;
        }
          
     // Write a trigger where if one contact is delelete than autmatically another contact will be created


}
