@isTest
private class RSI_AWSTests {
    @testSetup static void createData(){
        //create Opportunity.
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
        qd.SBQQ__ElectronicSignature__c = True;
        qd.SBQQ__SignatureStatus__c = 'Sent';
        insert qd;
    }
    
    static testMethod void testCallout() {
        
        Opportunity opp = [SELECT id FROM opportunity limit 1];
        SBQQ__Quote__c createQuote = [SELECT id FROM SBQQ__Quote__c limit 1];
        Document documentObj = [SELECT id FROM Document limit 1];
        SBQQ__QuoteDocument__c qd = [SELECT id FROM SBQQ__QuoteDocument__c limit 1];
        //create Quote Document
        Map<Id,SBQQ__QuoteDocument__c> mapOfQuoteDocument = new Map<Id,SBQQ__QuoteDocument__c>();
        mapOfQuoteDocument.put(qd.Id, qd);
        
        System.Test.startTest();
        	System.Test.setMock(HttpCalloutMock.class, new RSI_MockAWSResponse());
        	System.enqueueJob(new RSI_QuoteToAWS(mapOfQuoteDocument));
        	
        	//System.assertEquals(200, res.getStatusCode());
        	AsyncApexJob[] jobs = [Select Id FROM AsyncApexJob 
                             WHERE ApexClass.Name = 'RSI_QuoteToAWS'];
        	system.assert(!jobs.isEmpty(),'queueable should be created');
        	System.Test.stopTest();
    }
    
}