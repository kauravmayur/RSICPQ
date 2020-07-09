public class S3Controller {
    //@AuraEnabled
    public static void UploadDocToS3Server(string recordId)
    {
        UploadDocument(recordId);
    }
    
    //@future(callout=true)
    public static void UploadDocument(string recordId)
    {
        //S3 Key 
        String key = 'AKIAIK7UX5MQDVO54FRA'; 
        //S3 Secret Key 
        String secret = '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';
        String bucket = 'lbs-cpq'; 
        String host = 's3.ap-south-1.amazonaws.com';
        String method = 'PUT';
        AWSService service=new AWSService(key,secret,bucket,method,host);
        service.UploadDocuments(recordId);
    }
}