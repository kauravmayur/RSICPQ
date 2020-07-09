public class RSI_CPQ_TrialPush {
    
   //method to use the S3 webservice and save pdf file
    public static void saveToS3(String binaryPDF,String docName,String bucketname,String method,String contentType,String region,String key,String secret){
        /*  Input Variable Explanations
        binaryPDF -- this is a base64 Encoded binary string representation of a PDF I get from a different web service
        docName --  any name you want to use as the saved document name
        bucketname --  the Amazon S3 bucket you are saving to
        method --  I currently only use PUT
        contentType --  I leave this blank and it seems to work fine
        region --  !!!Important, this needs to be the region that the S3 bucket is set to, for example '-us-west-2'
        key --  this is the key you generate in the AWS console under Identity & Access Management for the user account setup to access the S3 bucket
        secret --  this is the secret you generate during the same process
        */

        //setup variables
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');    //this is needed for the PUT operation and the generation of the signature.  I use my local time zone.
        //format('EEE, dd MMM yyyy HH:mm:ss z','America/Denver')
        String filename;
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        filename = '2020/May/' +    //Include any folders and subfolders you are using in your S3 Bucket
            docName.replace(' ', '+');   //this replaces any spaces in the desired document name with a Plus symbol '+', as the filename needs to be URL friendly
        
        req.setHeader('Content-Type', contentType);
        req.setMethod(method);
        req.setHeader('Host','s3' + region + '.amazonaws.com');  //path style
        req.setEndpoint('https://'+bucketname + '.s3'+ region + '.amazonaws.com' + '/' + filename);   //path style
        req.setHeader('Date', formattedDateString);
        req.setHeader('Authorization',createAuthHeader(method,contentType,filename,formattedDateString,bucketname,key,secret));
        
        if(binaryPDF != null && binaryPDF != ''){
            Blob pdfBlob = EncodingUtil.base64Decode(binaryPDF);
            req.setBodyAsBlob(pdfBlob);
            req.setHeader('Content-Length', string.valueOf(binaryPDF.length()));
            
            //Execute web service call
            try {
                HTTPResponse res = http.send(req);
                System.debug('MYDEBUG: ' + docName + ' RESPONSE STRING: ' + res.toString());
                System.debug('MYDEBUG: ' + docName + ' RESPONSE STATUS: '+res.getStatus());
                System.debug('MYDEBUG: ' + docName + ' STATUS_CODE:'+res.getStatusCode());
                
            } catch(System.CalloutException e) {
                system.debug('MYDEBUG: AWS Service Callout Exception on ' + docName + 'ERROR: ' + e.getMessage());
            }
        }
    }
    
    //create authorization header for Amazon S3 REST API
    public static string createAuthHeader(String method,String contentType,String filename,String formattedDateString,String bucket,String key,String secret){
        string auth;
        String stringToSign = method+'\n\n'+contentType+'\n'+formattedDateString+'\n/'+bucket+'/'+filename;
        Blob mac = Crypto.generateMac('HMACSHA256', blob.valueof(stringToSign),blob.valueof(secret));
        String sig = EncodingUtil.base64Encode(mac);
        auth = 'AWS' + ' ' + key + ':' + sig;
        return auth;
    }    
    
    public static void getFile(/*String binaryPdf*/) {
        Document doc = [select Body,ContentType,Name from Document WHERE Name='Q-00005-20200605-0543.pdf'];
        Blob fileContent = doc.Body;
        String binaryPdf = EncodingUtil.base64Encode(fileContent);
        //String csvBody = EncodingUtil.base64Encode(csvBlob);
        saveToS3(binaryPdf, doc.Name, 'lbs-cpq','PUT', '','.ap-south-1', 'AKIAJAMYPYEJS3IN24QA','sV++zb9CREh3CMJl4Aoy8934fPaOdRIzbhv5P0ZJ');
        //return binaryPdf;
    }
}