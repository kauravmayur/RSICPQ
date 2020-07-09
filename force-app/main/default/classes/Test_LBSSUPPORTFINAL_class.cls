@isTest
public class Test_LBSSUPPORTFINAL_class {
    
    public static testMethod void getContact(){
        
        Id p = [select id from profile where name='Partner Community User RSI Partner'].id;
        
        Account ac = new Account(name ='TestAcc') ;
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.id); 
        insert con;  
        system.debug('con in LBSSUPPORT_FINAL :: '+con);
        
        User usr = new User(alias = 'test123', email='test123@noemail.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                            ContactId = con.Id,
                            timezonesidkey='America/Los_Angeles', username='tester123@asdf1290.com');
        
        insert usr;
        system.debug('useCont'+usr.ContactId);
        
        system.runAs(usr) 
        {
            User u1 = [select id,contactid from user where id=:UserInfo.getUserId()];
            Contact con1 = [Select LastName from Contact where id=:u1.contactId];
            System.assertEquals(con1.LastName,'testCon');
            LBSSUPPORTFINAL_class.getContactInfo();
        }
        
    }
}