@istest
public class LBSDynamicObjectListDisplay_TestClass {
    
    @testSetup static void setupMethod() {
        Account account = new Account();
        account.Type = 'Warehouse';
        account.name ='testAccount';
        account.BillingState = 'Alberta';
        insert account;
        
        Contact con = new Contact(LastName ='testCon',AccountId = account.id); 
        insert con;
        
        Id p = [select id from profile where name='Partner Community User RSI Partner'].id;
        User usr = new User(alias = 'test123', email='test123@noemail.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                            ContactId = con.Id,
                            timezonesidkey='America/Los_Angeles', username='tester123@asdf1290.com');
        
        insert usr;
        
    }
    
    @isTest
    private static void testFetchObject(){
        LBSDynamicObjectListDisplay.fetchObject('Account', '', '', 'asc');
        Account acc = [Select Name from Account limit 1];
        System.assertEquals(acc.Name,'testAccount');
        
    }
    @isTest
    private static void testFetchContactDublicate(){
        LBSDynamicObjectListDisplay.fetchObject('Account', 'Name', 'Name', 'asc');
        LBSDynamicObjectListDisplay.getContactInfo();
        Contact con = [Select LastName from Contact limit 1];
        System.assertEquals(con.LastName,'testCon');
        
        Support__c support = new Support__c();
        support.Contact__c = con.id;
        support.name = 'Test Support';
        support.Subject__c = 'Test Support';
        support.Type__c = 'Product';
        support.Description__c = 'Sample Support';
        Test.StartTest();
        insert support;
        string recordName = LBSDynamicObjectListDisplay.getRecordName(support.id);
        System.assertEquals(recordName,'Test Support');
        Test.StopTest();
    }
    
}