trigger Trigger_RSI_QuoteToAWS on SBQQ__QuoteDocument__c (after insert) {
	RSI_checkMetadata.performMetaActions(trigger.newMap);        
}