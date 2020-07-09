public with sharing class RSI_checkMetadata {
    
    Public Static AWSSettings__mdt awsSettings = [SELECT Push_to_AWS__c, Electronic_Signature__c, Signature_Status__c FROM AWSSettings__mdt WITH SECURITY_ENFORCED];
    public static void performMetaActions(Map<Id,SBQQ__QuoteDocument__c> quoteDocumentIdMapTest) {
        if(awsSettings.Push_to_AWS__c == true) {
            if(awsSettings.Electronic_Signature__c == true && awsSettings.Signature_Status__c!='') {
                for(SBQQ__QuoteDocument__c qd : quoteDocumentIdMapTest.values()) {
                    if(qd.SBQQ__ElectronicSignature__c==true && (awsSettings.Signature_Status__c==qd.SBQQ__SignatureStatus__c)) {
                        checkMetaFields(quoteDocumentIdMapTest);
                    }
                }
            }
            
            else {
                checkMetaFields(quoteDocumentIdMapTest);
            }
        }
    }
    
    private static void checkMetaFields(Map<Id,SBQQ__QuoteDocument__c> quoteDocumentIdMap) {
        if(!Test.isRunningTest()){System.enqueueJob(new RSI_QuoteToAWS(quoteDocumentIdMap));}
    }
}