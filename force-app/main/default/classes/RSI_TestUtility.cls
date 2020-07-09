public class RSI_TestUtility {
    @future
    public static void getQuoteDocument(){
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.CloseDate = system.today();
        opp.StageName = 'Prospecting';
        insert opp;
        
        //create a quote
        SBQQ__Quote__c createQuote = new SBQQ__Quote__c();
        createQuote.SBQQ__Opportunity2__c = opp.Id;
        insert createQuote;
        
        //Create Document Now.
        Document documentObj;
        documentObj = new Document();
        documentObj.Body = Blob.valueOf('Some Document Text');
        documentObj.ContentType = 'application/pdf';
        documentObj.DeveloperName = 'my_document';
        documentObj.IsPublic = true;
        documentObj.Name = 'MyDocument';
        documentObj.FolderId = UserInfo.getUserId();
        insert documentObj;
        
        SBQQ__QuoteDocument__c qd = new SBQQ__QuoteDocument__c();
        qd.SBQQ__Quote__c = createQuote.Id;
        qd.SBQQ__Opportunity__c = opp.Id;
        qd.SBQQ__OutputFormat__c = 'PDF';
        qd.SBQQ__ListAmount__c = 20;
        qd.SBQQ__Version__c = 1;
        qd.SBQQ__Template__c = 'Custom Quote Template';
        qd.SBQQ__DocumentId__c = documentObj.Id;
        
        insert qd;
    }
}