trigger DeleteAndUpdate on Contact (after delete) {

    List<Contact> con = new List<Contact>();

    for(Contact dlcon: Trigger.old){
        Contact c = new Contact();
        c.LastName = dlcon.LastName + 'Deleted';
        c.FirstName = dlcon.FirstName+'Deleted';
        con.add(c);
    }

     if(!con.isEmpty()){
         insert con;
     }
}