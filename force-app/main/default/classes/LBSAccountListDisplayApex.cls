public with sharing class LBSAccountListDisplayApex {
    @AuraEnabled
    //public static AccountPagerWrapper fetchAccount(Decimal pageNumber ,Integer recordToDisply, Integer toalNumberOfAccount) {
    //public static AccountPagerWrapper fetchAccount(Integer toalNumberOfAccount, String sortByAccountField, String sortAscDescAccount, String fieldsToDisplay) {
    public static List<Account> fetchAccount(Integer toalNumberOfAccount, String sortByAccountField, String sortAscDescAccount, String fieldsToDisplay, String dynamicHeaders) {
        //Integer pageSize = recordToDisply;
        //Integer offset = ((Integer)pageNumber - 1) * pageSize;
        Id userId = UserInfo.getUserId();
        
      List<Account> acc = New List<Account>();
        
        string sortby = sortByAccountField;
        string querystr = '';
       
        //applicantQuizzes = database.query(querystr);
        
        // create a instance of wrapper class.
   //AccountPagerWrapper obj =  new AccountPagerWrapper();
        // set the pageSize,Page(Number), total records and accounts List(using OFFSET)   
        //obj.pageSize = pageSize;
        //obj.page = (Integer) pageNumber;
     //obj.total = [SELECT count() FROM account];
        //obj.accounts = [SELECT Id, Name,Phone,AnnualRevenue FROM Account where OwnerId =:userinfo.getuserid()  ORDER BY AnnualRevenue asc LIMIT :recordToDisply OFFSET :offset];
        
        system.debug('fieldsToDisplay'  + fieldsToDisplay);
        
        querystr = 'SELECT ' +fieldsToDisplay + ' FROM Account where OwnerId =:userId  LIMIT :toalNumberOfAccount ';
        //querystr		= 'SELECT Id, Name,Phone,AnnualRevenue FROM Account where OwnerId =:userId  ORDER BY Name asc LIMIT :toalNumberOfAccount';
        //querystr += sortby ;
        //select 
        
        //system.debug(querystr);
        acc = Database.query(querystr);
        
        //system.debug('Testtt' + obj.accounts);
        //acc = [SELECT Id, Name,Phone,AnnualRevenue FROM Account where OwnerId =:userinfo.getuserid()  ORDER BY Name asc LIMIT :toalNumberOfAccount];
       	//acc = [SELECT Id, Name,Phone,AnnualRevenue FROM Account where OwnerId =:userinfo.getuserid()  ORDER BY Name asc LIMIT :toalNumberOfAccount];
        //acc = [querystr];
        
        // return the wrapper class instance .
        //return obj;
        system.debug(acc);
        return acc;
        
    }
    
    // create a wrapper class with @AuraEnabled Properties    
    public class AccountPagerWrapper {
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer page {get;set;}
        @AuraEnabled public Integer total {get;set;}
        @AuraEnabled public List<Account> accounts {get;set;}
    }
}