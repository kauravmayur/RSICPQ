public class RSI_checkMetadata1 {
    @future(callout=false)
    //public static void performMetaActions(Map<Id,SBQQ__QuoteDocument__c> quoteDocumentIdMapTest) {
    public static void performMetaActions(Set<Id> quoteDocumentId) {    
        Map<Id,SBQQ__QuoteDocument__c> quoteDocumentIdMapTest = new Map<Id,SBQQ__QuoteDocument__c>([SELECT Id, SBQQ__ElectronicSignature__c, SBQQ__SignatureStatus__c FROM SBQQ__QuoteDocument__c Where Id IN: quoteDocumentId]);
        RSI_QuoteToAWS pushQuoteToAws;
        AWSSettings__mdt awsSettings = [SELECT Push_to_AWS__c, Electronic_Signature__c, Signature_Status__c FROM AWSSettings__mdt];
    	if(awsSettings.Push_to_AWS__c == true) {
            if(awsSettings.Electronic_Signature__c == true || awsSettings.Signature_Status__c!='') {
                for(SBQQ__QuoteDocument__c qd : quoteDocumentIdMapTest.values()) {
                    if(qd.SBQQ__ElectronicSignature__c==true || (awsSettings.Signature_Status__c==qd.SBQQ__SignatureStatus__c) ) {
                        System.enqueueJob(new RSI_QuoteToAWS(quoteDocumentIdMapTest));
                    }
                }
            }
            else {
                System.enqueueJob(new RSI_QuoteToAWS(quoteDocumentIdMapTest));
            }
        }
    }
}