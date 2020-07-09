public  with sharing class RSI_QuoteToAWS implements Queueable, Database.AllowsCallouts{
    List<Id> storeQuoteDocumentIds = new List<Id>();
    List<SBQQ__QuoteDocument__c> createdQuoteDocument;
    List<SBQQ__QuoteDocument__c> updateDocument = new List<SBQQ__QuoteDocument__c>();
    List<Id> docIds = new List<Id>();
    List<Id> opportunityIds = new List<Id>();
    NamedCredential getEndpoint;
    public String calloutLabel = System.Label.RSI_AWS_Callout;
    public String awsFolder    = System.Label.RSI_AWS_Folder;
    Map<Id, Document> mapOfDocuments;
    AWSSettings__mdt awsSettings;
    String captureAllOppSta = '';
    List<String> listOfOppStages;
    HTTPResponse res;
    
    public RSI_QuoteToAWS(Map<Id,SBQQ__QuoteDocument__c> quoteDocumentIdMap) {
        Set<Id> setOfKeysets = new Set<Id>();
        for(Id i : quoteDocumentIdMap.keySet()) {
            setOfKeysets.add(i);
        }
        String queryStart = 'SELECT';
        String queryEnd = 'FROM SBQQ__QuoteDocument__c WHERE Id IN :setOfKeysets AND SBQQ__Opportunity__c!=null';
        string queryBoby = readFieldSet('LBSQuoteDocument', 'SBQQ__QuoteDocument__c');
        
        string query = queryStart+' '+queryBoby+' '+queryEnd;
        String oppQuery = ' AND SBQQ__Opportunity__r.StageName IN :listOfOppStages';
        awsSettings = [SELECT Opportunity_Stage__c FROM AWSSettings__mdt WITH SECURITY_ENFORCED];
        if(awsSettings.Opportunity_Stage__c!=null){
            captureAllOppSta = awsSettings.Opportunity_Stage__c;
            listOfOppStages = captureAllOppSta.split(',');
            query = query+oppQuery+' WITH SECURITY_ENFORCED';
        }else{
            query = query+' WITH SECURITY_ENFORCED';
        }
        createdQuoteDocument = Database.query(query);
        for(SBQQ__QuoteDocument__c getAllDocsIds : createdQuoteDocument) {
            docIds.add(getAllDocsIds.SBQQ__DocumentId__c);
            opportunityIds.add(getAllDocsIds.SBQQ__Opportunity__c);
        }
        mapOfDocuments = new Map<Id, Document>([select Body,ContentType,Name from Document WHERE Id IN :docIds WITH SECURITY_ENFORCED]);
        getEndpoint = [SELECT Endpoint FROM NamedCredential WHERE MasterLabel = :calloutLabel];
    }
    
    public void execute(QueueableContext context) {
        for(Document d : mapOfDocuments.values()) {
            try {
                HttpRequest reqHTTP = new HttpRequest();
                reqHTTP.setEndpoint('callout:'+calloutLabel+'/' + getHTMLEncodedVals(awsFolder + '/' + d.Name));
                reqHTTP.setMethod('PUT');
                Blob blobFileContent = d.Body;
                reqHTTP.setBodyAsBlob(blobFileContent);
                Http http = new Http();
                if(!Test.isRunningTest()) {
                    res = http.send(reqHTTP);
                }
                if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                    for(SBQQ__QuoteDocument__c qd : createdQuoteDocument) {
                        qd.Document_Link__c = getEndpoint.Endpoint+awsFolder+'/'+d.Name;
                        updateDocument.add(qd);
                    }
                }
            }
            catch (Exception ex) {
                ex.getMessage();
            }
            
        } update updateDocument;  
    }
    
    public static String readFieldSet(String fieldSetName, String objectName){
        string queryStr = '';
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(objectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = describeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        for(Schema.FieldSetMember fieldSetMemberObj : fieldSetObj.getFields()){
            if(String.isEmpty(queryStr)){
                queryStr = fieldSetMemberObj.getFieldPath();
            }
            else{
                queryStr = queryStr+','+fieldSetMemberObj.getFieldPath();
            }
        }
        return queryStr; 
    }  
    
    public static string getHTMLEncodedVals (String strInput) {
        strInput = strInput.replace(' ', '%20');
        strInput = strInput.replace('\'', '%27');
        return strInput;
    }   
}