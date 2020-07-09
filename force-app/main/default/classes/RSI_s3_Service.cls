public class RSI_s3_Service {
    //This method returns GMT time.
    //Document doc = [SELECT Body,Name, Id FROM Document WHERE Id = '0155w000003g503AAA'];
    public Static Document doc;
    public Static String body;
    public Static String algorithm = 'AWS4-HMAC-SHA256';
    public Static String region = 'ap-south-1';
    public Static String serviceName = 's3';
    public Static String bucketName = 'lbs-cpq';
    public Static String accessKeyId = 'AKIAIK7UX5MQDVO54FRA';
    public Static String secretKey = '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';
    public Static String stringToSign='';
    public Static Blob blobFileContent;
    public Static String fileName;
    
    public static String generatedTime() {
        String currentDateOnly = DateTime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        return currentDateOnly;
    }
    
    
    //This method generates canonical request.
    //working fine. Tested the method with aws inputs.
    public static string generatedCanonicalRequest() {
    String canonicalRequest = '';
           canonicalRequest += 'PUT'+'\n';     
           canonicalRequest += generateURI()+'\n';
           canonicalRequest += getCanonicalHeaders(generateHeaders())+'\n';
           canonicalRequest += getSignedHeaders(generateHeaders())+'\n';
           canonicalRequest += generatePayload(); 
    String hashCanonicalRequest = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(canonicalRequest)));
    String finalHashCanonicalRequest = hashCanonicalRequest.toLowerCase();
    system.debug('hashed out canonical request--->'+finalHashCanonicalRequest);
    system.debug('************************************************************************************************');
    return finalHashCanonicalRequest;    
    }
	
    
    //This method generates the canonical headers and their values in lowercase.
    //https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
    public static string getCanonicalHeaders(Map<String,String> headers) {
        List<String> sortedHeaders = new List<String>();
        String canonicalHeaders = '';
        sortedHeaders.addAll(headers.keySet());
        sortedHeaders.sort();
        for(String s : sortedHeaders) {
		canonicalHeaders  += s.toLowerCase() + ':'+headers.get(s) + '\n';
	    }
        //system.debug('Canonical Headers--->'+canonicalHeaders);
        return canonicalHeaders;
    }
    //This method generates the signed headers in lowercase.
    //https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html#canonical-request
    public static string getSignedHeaders(Map<String,String> headers) {
        List<String> sortedHeaders = new List<String>();
        sortedHeaders.addAll(headers.keySet());
        sortedHeaders.sort();
        String buffer = '';
        for(String header : sortedHeaders) {
            if(buffer.length()>0) buffer+=';';
            buffer+= header.toLowerCase();
        }
        //system.debug('Signed Headers--->'+buffer);
        return buffer;
    }
    //This method generates payload.
    public static string generatePayload() {
        String payload = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf('')));
        String finalPayload = payload.toLowerCase();
        system.debug('finalPayload'+finalPayload);
        return finalPayload;
    }
    //document to be uploaded.
    public static string generateFileName(String documentId) {
        
        doc = [SELECT Body,Name, Id FROM Document WHERE Id = :documentId];
        fileName = getHTMLEncodedVals('2020/May' + '/' + doc.Name);
        blobFileContent = doc.Body;
        body = EncodingUtil.base64Encode(doc.Body);
        return fileName;
    }
    public static string getHTMLEncodedVals (String strInput) {
        strInput = strInput.replace(' ', '%20');
        strInput = strInput.replace('\'', '%27');
        return strInput;
    }
    
    //This methods give the encoded URI.
    //https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_encodingUtil.htm
    public static String generateURI() {
        //try the uri https://s3.amazonaws.com/lbs-cpq/2020/fileName
        String url = 'https://'+bucketName+'.'+serviceName+'.'+region+'.'+'amazonaws.com/';
        String encodedURL = EncodingUtil.urlEncode(url, 'UTF-8');
        system.debug('Encoded URL---->'+encodedURL);
        return encodedURL;
    }
    
    //This method generates headers.
    public static Map<String,String> generateHeaders() {
        Map<String,String> generateHeaders = new Map<String,String>();
        generateHeaders.put('ACL', 'public-read-write');
        generateHeaders.put('Date', generatedTime());
        generateHeaders.put('x-amz-content-sha256', 'UNSIGNED-PAYLOAD');
        generateHeaders.put('Host','s3.amazonaws.com');
        generateHeaders.put('Content-type', 'application/pdf');
        generateHeaders.put('Connection', 'keep-alive');
        generateHeaders.put('Content-Length', String.valueOf(body.length()));
        //generateHeaders.put('Authorization',generateAuthorizationHeader());
        return generateHeaders;
    }
    //Create the date in yyyymmdd format
    //https://docs.aws.amazon.com/general/latest/gr/sigv4-create-string-to-sign.html
    public static String yyyymmddFormat() {
        Datetime d = Datetime.now();
        //String formatDate = String.valueOf(currentDate.year())+String.valueOf(currentDate.month())+String.valueOf(currentDate.day());
        String formatDate = d.format('yyyy/MM/dd');
        formatDate = formatDate.replace('/', '');
        system.debug('yyyyMMdd--->'+formatDate);
        return formatDate;
    }
    
    //Lets get the String to Sign.
    public static String stringToSign() {
        /****As mentioned in https://docs.aws.amazon.com/general/latest/gr/sigv4-create-string-to-sign.html****/
        //String encodedRegion = EncodingUtil.urlEncode(region, 'UTF-8');
        //String encodedServiceName = EncodingUtil.urlEncode(serviceName, 'UTF-8');
        /******************************************************************************************************/
        String stringToSign = '';
        stringToSign += algorithm + '\n';
        stringToSign += generatedTime()+'\n';
        stringToSign += credentialsScope();
        //system.debug('stringToSign--->'+stringToSign);
        //Creating the hash of Canonical Request.
        String hashedCanonicalRequest = generatedCanonicalRequest();
        stringToSign += hashedCanonicalRequest;
        system.debug(stringToSign);
        return stringToSign;
    }
    
    public static String credentialsScope() {
        String encodedRegion = EncodingUtil.urlEncode(region, 'UTF-8');
        String encodedServiceName = EncodingUtil.urlEncode(serviceName, 'UTF-8');
        String credScopeURL = yyyymmddFormat()+'/'+encodedRegion+ '/'+ encodedServiceName+'/'+'aws4_request'+'\n';
        return credScopeURL;
    }
    
    //Now calculate signature.
    //involves deriving signing key : https://docs.aws.amazon.com/general/latest/gr/sigv4-calculate-signature.html
    public static String deriveSigningKey() {
        String kSecret = 'AWS4'+secretKey;
        Blob kDate = crypto.generateMac('HMAC-SHA256', Blob.valueOf(yyyymmddFormat()), Blob.valueOf(kSecret)); //The order specified in the crypto is different than AWS.
		Blob kRegion = crypto.generateMac('HMAC-SHA256', Blob.valueOf(region), kDate);
        Blob kService = crypto.generateMac('HMAC-SHA256', Blob.valueOf(serviceName), kRegion);
        Blob kSigning = crypto.generateMac('HMAC-SHA256', Blob.valueOf('aws4_request'), kService);
        String signingKey = EncodingUtil.convertToHex(crypto.generateDigest('SHA-256', kSigning));
        
        //EncodingUtil.
        String derivedSigningKey = signingKey.toLowerCase();
        system.debug('Derived Signing key---->'+derivedSigningKey);
        return derivedSigningKey;
    }
    
    //Calculating the signature.
    public static String generateSignature() {
        String signature = EncodingUtil.convertToHex(crypto.generateMac('HMAC-SHA256', Blob.valueOf(stringToSign()), 
                                                                        Blob.valueOf(deriveSigningKey())));
        //EncodingUtil.
        system.debug('Signature---->'+signature);
        return signature;
    }
    
    //Generate authorization header.
    //https://docs.aws.amazon.com/general/latest/gr/sigv4-add-signature-to-request.html
    public static String generateAuthorizationHeader() {
        String authHeader = '';
        authHeader += algorithm + ' ';
        authHeader += 'Credential='+accessKeyId+'/'+credentialsScope()+',';
        authHeader += 'SignedHeaders='+getSignedHeaders(generateHeaders())+',';
        authHeader += 'Signature='+generateSignature();
        system.debug('Authorization Header----->'+authHeader);
        return authHeader;
    }
    
    //Send the Request.
    public static void sendRequest() {
        generatedCanonicalRequest();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://lbs-cpq.s3.ap-south-1.amazonaws.com/2020/May/Q-00015-20200603-0301.pdf');
        req.setMethod('PUT');
        req.setBodyAsBlob(blobFileContent);
        req.setHeader('ACL', 'public-read-write');
        req.setHeader('Date', generatedTime());
        req.setHeader('x-amz-content-sha256', 'UNSIGNED-PAYLOAD');
        req.setHeader('Host','s3.amazonaws.com');
        req.setHeader('Content-type', 'application/pdf');
        req.setHeader('Connection', 'keep-alive');
        req.setHeader('Content-Length', String.valueOf(body.length()));
        req.setHeader('Authorization',generateAuthorizationHeader());
       
        HttpResponse response = http.send(req);
        system.debug('Response----->'+response);
    }
}