public with sharing class LBSDynamicObjectListDisplay {
    
    public class ResultWrapper {
        @AuraEnabled
        public list<SObject> lstSObject;
        @AuraEnabled
        public list<FieldsWrapper> lstFields;
        @AuraEnabled
        public string objectLabel;
        @AuraEnabled
        public string error;
        
        public ResultWrapper(list<SObject> lstSObject, list<FieldsWrapper> lstFields, string objectLabel,string error) {
            this.lstSObject = lstSObject;
            this.lstFields  = lstFields;
            this.objectLabel = objectLabel;
            this.error = error;
        }
    }
    
    public class FieldsWrapper {
        
        @AuraEnabled
        public String fieldPath { get;set; }
        @AuraEnabled
        public String label     { get;set; }
        @AuraEnabled
        public String type      { get; set; }
        
        public FieldsWrapper(String fieldPath, String strLabel, String strType) {
            this.fieldPath = fieldPath;
            this.label = strLabel;
            this.type = strType;
        }
    }
    
    @AuraEnabled
    public static ResultWrapper  fetchObject( String strSObjectName, String strFieldsetName, String sortByFieldName, String ascDesc) {
        //String urlpathprefix = [Select UrlPathPrefix from Network where Id =:Network.getNetworkId()].UrlPathPrefix;
        Set<String> setFieldsToQuery = new set<String>();
        List<FieldsWrapper> lstFieldsetWrapper = new List<FieldsWrapper>();
        list<SObject> lstSObject;
        Map<String, String> mapfiledpathlael = new Map<String, String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType objSchema = schemaMap.get(strSObjectName);
        Map<String, Schema.SObjectField> fieldMap = objSchema.getDescribe().fields.getMap();
        
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(strSObjectName);
        
        string error = '';
        strFieldsetName = strFieldsetName.replaceAll( '\\s+', '');
        
        for(String fields : strFieldsetName.split(',')) { 
            if(String.isNotBlank(fields) && fieldMap.containsKey(fields)){
        		lstFieldsetWrapper.add(new FieldsWrapper(fieldMap.get(fields).getDescribe().getName(), fieldMap.get(fields).getDescribe().getLabel(),STring.valueOf(fieldMap.get(fields).getDescribe().getType())));
            }
            else{
                System.debug('error : '+error);
                error = (String.isEmpty(error)) ? System.Label.ErrorPrefix+' \''+fields+'\'' : error +', \''+ fields+'\'';
            }
        } 
        error = error+ ' '+System.Label.onEntity+' '+strSObjectName;
        Id userId = UserInfo.getUserId();
        
        String queryString = 'Select  id, '+strFieldsetName;
        setFieldsToQuery.remove('id');
        queryString += String.join( new List<String>(setFieldsToQuery), ',');
        queryString.removeEnd(',');
        queryString += ' FROM ' + strSObjectName + ' WHERE OwnerId =:userId WITH SECURITY_ENFORCED';
        
        
        if(String.isNotBlank(sortByFieldName) && String.isNotBlank(ascDesc)){
        	queryString += ' Order by ' +  sortByFieldName + ' ' + ascDesc;
        	system.debug('queryString--->' + queryString);
        }
        try{
            system.debug('queryString 1--->' + queryString);
        	 lstSObject = Database.query(String.escapeSingleQuotes(queryString));    
        }
        catch(exception ex){
            lstSObject = new list<SObject>();
            return new ResultWrapper(lstSObject,lstFieldsetWrapper, convertType.getDescribe().getLabel(), error); 
        }
        return new ResultWrapper(lstSObject,lstFieldsetWrapper, convertType.getDescribe().getLabel(),'');
    }
   @AuraEnabled
    public static User getContactInfo(){
        User u = [Select ContactId,Contact.AccountId from User where id=:UserInfo.getUserId() WITH SECURITY_ENFORCED Limit 1];
        if(u.contactId != null){
            return u;
        }else{
            return null;
        }
    }
       
    @AuraEnabled
    public static String getRecordName(id recordId){
		Support__c support = [Select Name from Support__c where id=: recordId WITH SECURITY_ENFORCED];
			if(support != null){
				return support.Name;
			}else{
				return null;
			}
	}
}