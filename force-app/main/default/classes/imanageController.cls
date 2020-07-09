public class imanageController {
    @AuraEnabled
    public static List<Contact> getcontacts(){
        List<contact> conList = [SELECT Id, Name, OwnerId, Owner.Name, CreatedDate, LeadSource, Email, Phone 
                                 FROM contact
                                 WHERE LeadSource != null
                                 AND Phone != null
                                 AND Email != null];
        return conList;
    }
    
    @AuraEnabled
    public static User getCurrentUser(){
        User users = [SELECT Id, Name, LastName, FirstName, Email, Phone 
                      FROM User
                      WHERE id = :userInfo.getUserId()];
        return users;
    }
    
    @AuraEnabled
    public static String getfirstlastname()
    {
        String returnString = '' ;
        String FirstName = UserInfo.getFirstName();//Returns the context user's firstname
        System.Debug('FirstName-' + FirstName);
        String LastName = UserInfo.getLastName();//Returns the context user's last name.
        System.Debug('LastName-' + LastName);
        returnString = FirstName.toUpperCase().substring(0,1) + ''+ 
            LastName.toUpperCase().substring(0,1);
        system.debug('returnString'+returnString);
        return returnString;
    }
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        System.debug('select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5');
        String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}