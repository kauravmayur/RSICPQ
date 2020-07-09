public with sharing class FileUploadController {
    
    
    @AuraEnabled
    public static ResultWrapper getData(Id matterId) {
        String objectName = '';
        String myIdPrefix = String.valueOf(matterId).substring(0, 3);
        Map < String, Schema.SObjectType > gd = Schema.getGlobalDescribe();
        for (Schema.SObjectType stype: gd.values()) {
            Schema.DescribeSObjectResult r = stype.getDescribe();
            String prefix = r.getKeyPrefix();
            if (prefix != null && prefix.equals(myIdPrefix)) {
                objectName = r.getName();
                System.debug('Object Name! ' + objectName);
                break;
            }
        }
        ResultWrapper rw = new ResultWrapper();
        if(objectName == 'Case'){
        	Case matterDetail = [SELECT Id, CaseNumber from Case where id = : matterId];  
            rw.objName = objectName;
            rw.val = 'Matter - '+matterDetail.CaseNumber;
            return rw;
        }
        else if(objectName == 'Account'){
            Account accDetails = [Select Id, Name from Account Where id = : matterId];
            rw.objName = objectName;
            rw.val = accDetails.Name;
            return rw;
        }
        else{
            return null;
        }
        
    }
    public class ResultWrapper{
        @AuraEnabled public String objName {get;set;}
        @AuraEnabled public String val{get;set;}
    }
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        
        insert oAttachment;
        
        return oAttachment.Id;
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        
        update a;
    }
}