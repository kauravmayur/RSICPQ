public class RSI_s3_Service_New {
    public Static Document doc;
    public Static String body='';
    public Static String algorithm = 'AWS4-HMAC-SHA256';
    public Static String region = 'ap-south-1';
    //public Static String region = 'us-east-1';
    public Static String serviceName = 's3';
    public Static String bucketName = 'lbs-cpq';
   // public Static String bucketName = 'testing123cpq';
    public Static String accessKeyId = 'AKIAJWEM3DJXEF2PJTFA';
    public Static String secretKey = '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';
    public Static String stringToSign='';
    public Static Blob blobFileContent;
    public Static String fileName;
    public Static String httpMethod = 'PUT';
    
    /******************************/
    
    
    /******************************/
    
    //This methods generates the Canonical URI.
    public static String generateCanonicalURI() {
        String url = 'https://'+bucketName+'.'+serviceName+'.'+region+'.'+'amazonaws.com/';
        String encodedURL = EncodingUtil.urlEncode(url, 'UTF-8');
        //system.debug('Encoded URL---->'+encodedURL);
        return encodedURL;
    }
    
    //This methods returns the date in yyyyMMdd format.
    /*
    public static String yyyymmddFormat() {
        Datetime d = Datetime.now();
        String formatDate = d.format('yyyy/MM/dd');
        formatDate = formatDate.replace('/', '');
        system.debug('yyyyMMdd--->'+formatDate);
        return formatDate;
    }
*/
    public static String yyyymmddFormat() {
        Datetime d = Datetime.now();
        String formatDate = String.valueOf(d.formatGmt('YYYYMMdd'));
        //formatDate = formatDate.replace('/', '');
        system.debug('yyyyMMdd--->'+formatDate);
        return formatDate;
    }
    
    //This methods generates GMT time.
    
    public static String generatedTime() {
        String currentDateOnly = DateTime.now().format('EEE, dd MMM yyyy HH:mm:ss z', 'America/New_York');
        system.debug('current date: '+currentDateOnly);
        return currentDateOnly;
    }
    
    /*
    public static String generatedTime() {
        String currentDateOnly = DateTime.now().formatGmt('YYYYMMdd\'T\'HHmmss\'Z\'');
        Datetime.now().format('EEE, dd MMM yyyy HH:mm:ss z','America/New_York'); 
        system.debug('current date: '+currentDateOnly);
        return currentDateOnly;
    }
*/
    
	
	
    /*
    public static String generatedTime() {
        String currentDateOnly = String.valueOf(DateTime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\''));
        system.debug('current date: '+currentDateOnly);
        system.debug('standardd time format--->'+Datetime.now());
        return currentDateOnly;
    }
*/
    
    /*
    public static String generatedTime() {
        String currentDateOnly = String.valueOf(DateTime.now());
        system.debug('current date: '+currentDateOnly);
        return currentDateOnly;
    }
	*/
    
	
    /*
    public static String oldgeneratedTime() {
        DateTime startDate = DateTime.Now();
        String formatStr = 'yyyyMMdd\'T\'HHmmSS\'Z\'';
        String currentDateOnly = startDate.format(formatStr);
        system.debug(currentDateOnly);
        //String currentDateOnly = DateTime.now().formatGMT('YYYYMMDD'T'HHMMSS'Z'');
        return currentDateOnly;
    }
		*/
    
    //This methods gets the file to be uploaded.
    
    public static string generateFileName() {
        doc = [SELECT Body,Name, Id FROM Document WHERE Id = '0155w000003g4z5AAA' ];
        system.debug('Document--->'+doc);
        fileName = getHTMLEncodedVals('2020/May' + '/' + doc.Name);
        //fileName = getHTMLEncodedVals('testing123cpq' + '/' + doc.Name);
        system.debug('File name--->'+fileName);
        blobFileContent = doc.Body;
        body = EncodingUtil.base64Encode(doc.Body);
        //system.debug('body-->'+body);
        return fileName;
    }
    
    
    public static string getHTMLEncodedVals (String strInput) {
        strInput = strInput.replace(' ', '%20');
        strInput = strInput.replace('\'', '%27');
        return strInput;
    }
    
    //Info about headers.
    public static Map<String,String> generateHeaders() {
        Map<String,String> generateHeaders = new Map<String,String>();
        //generateHeaders.put('ACL', 'public-read-write');
        generateHeaders.put('x-amz-acl','public-read');
        generateHeaders.put('x-amz-date', generatedTime());
        generateHeaders.put('x-amz-content-sha256', 'UNSIGNED-PAYLOAD');
        generateHeaders.put('Host','s3.amazonaws.com');
        generateHeaders.put('Content-type', 'application/pdf');
        generateHeaders.put('Connection', 'keep-alive');
        generateHeaders.put('Content-Length', String.valueOf(body.length()));
        //generateHeaders.put('Authorization',generateAuthorizationHeader());
        return generateHeaders;
    }
    
    //This methods generates Canonical Headers.
    public static String generateCanonicalHeaders() {
        Map<String, String> headers = generateHeaders();
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
    
    //This methods generates the signed Headers.
    public static string getSignedHeaders() {
        Map<String, String> headers = generateHeaders();
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
    
    //This methods generates hashed Payload with empty String.
    public static string generatePayload() {
        String payload = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf('')));
        String finalPayload = payload.toLowerCase();
        //system.debug('finalPayload'+finalPayload);
        return finalPayload;
    }
    /*
    public static String credentialsScope() {
        String encodedRegion = EncodingUtil.urlEncode(region, 'UTF-8');
        String encodedServiceName = EncodingUtil.urlEncode(serviceName, 'UTF-8');
        String credScopeURL = yyyymmddFormat()+'/'+encodedRegion+ '/'+ encodedServiceName+'/'+'aws4_request'+'\n';
        return credScopeURL;
    }
	*/
    
    public static String credentialsScope() {
        //String encodedRegion = EncodingUtil.urlEncode(region, 'UTF-8');
        //String encodedServiceName = EncodingUtil.urlEncode(serviceName, 'UTF-8');
        String credScopeURL = yyyymmddFormat()+'/'+region+ '/'+ serviceName+'/'+'aws4_request';
        String encodedURL = EncodingUtil.urlEncode(credScopeURL,'UTF-8');
        return credScopeURL;
    }
    
    
    
    //This methods generates the hash of canonical request.
    public static String generateHashCanonicalRequest() {
        String canonicalRequest = '';
        canonicalRequest += httpMethod+'\n';
        canonicalRequest += generateCanonicalURI()+'\n';
        canonicalRequest += generateCanonicalHeaders()+'\n';
        canonicalRequest += getSignedHeaders()+'\n';
        canonicalRequest += generatePayload();
        system.debug('canonical Request--->'+canonicalRequest);
        String hashCanonicalRequest = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(canonicalRequest)));
        String finalHashCanonicalRequest = hashCanonicalRequest.toLowerCase();
        system.debug('final hash canonical request--->'+finalHashCanonicalRequest);
        return finalHashCanonicalRequest;
    }
    
    //This methods generates the String to Sign.
    //task 2 completed.
    
    
    public static String stringToSign() 
    {
        //String stringToSign = method+'\n\n'+contentType+'\n'+formattedDateString+'\nx-amz-acl:public-read\n/'+bucketname+'/'+file; 
        String stringToSign = '';
        stringToSign += algorithm + '\n';
        stringToSign += generatedTime()+'\n';
        stringToSign += credentialsScope();
        //system.debug('stringToSign--->'+stringToSign);
        //Creating the hash of Canonical Request.
        String hashedCanonicalRequest = generateHashCanonicalRequest();
        stringToSign += hashedCanonicalRequest;
        system.debug(stringToSign);
        return stringToSign;
    }
    
    //task 3 -1 - Derive signing key
    public static String deriveSigningKey() {
        
        
        /*

kSecret = your secret access key
kDate = HMAC("AWS4" + kSecret, Date)
kRegion = HMAC(kDate, Region)
kService = HMAC(kRegion, Service)
kSigning = HMAC(kService, "aws4_request")



*/
        String kSecret = 'AWS4'+secretKey;
        Blob kDate = crypto.generateMac('HMAC-SHA256', Blob.valueOf(yyyymmddFormat()), Blob.valueOf(kSecret)); //The order specified in the crypto is different than AWS.
		Blob kRegion = crypto.generateMac('HMAC-SHA256', Blob.valueOf(region), kDate);
        
        Blob kService = crypto.generateMac('HMAC-SHA256', Blob.valueOf(serviceName), kRegion);
        Blob kSigning = crypto.generateMac('HMAC-SHA256', Blob.valueOf('aws4_request'), kService);
            String signingKey = EncodingUtil.convertToHex(crypto.generateDigest('SHA-256', kSigning));
        //EncodingUtil.
        //EncodingUtil.
        String derivedSigningKey = signingKey.toLowerCase();
        system.debug('Derived Signing key---->'+derivedSigningKey);
        return derivedSigningKey;
    }
    
    public static String generateSignature() {
        String signature = EncodingUtil.convertToHex(crypto.generateMac('HMAC-SHA256', Blob.valueOf(stringToSign()), 
                                                                        Blob.valueOf(deriveSigningKey())));
        //EncodingUtil.
        system.debug('Signature---->'+signature);
        return signature;
    }
    
    //task 4 - auth header
    public static String generateAuthorizationHeader() {
        String authHeader = ' ';
        authHeader += algorithm + ' ';
        authHeader += 'Credential='+accessKeyId+'/'+credentialsScope()+', ';
        authHeader += 'SignedHeaders='+getSignedHeaders()+', ';
        authHeader += 'Signature='+generateSignature();
        system.debug('Authorization Header----->'+authHeader);
        return authHeader;
    }
    
    public static void sendRequest() {
        //system.de
        fileName = generateFileName();
        system.debug('Entered send request File name--->'+fileName);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://testing123cpq.s3.amazonaws.com/'+fileName);
        system.debug('Endpoint URL--->'+'https://lbs-cpq.s3.ap-south-1.amazonaws.com/'+fileName);
        req.setMethod(httpMethod);
        req.setBodyAsBlob(blobFileContent);
        req.setHeader('ACL', 'public-read-write');
        req.setHeader('x-amz-acl','public-read');
        req.setHeader('x-amz-date', generatedTime());
        req.setHeader('x-amz-content-sha256', 'UNSIGNED-PAYLOAD');
        req.setHeader('Host','s3.amazonaws.com');
        req.setHeader('Content-type', 'application/pdf');
        req.setHeader('Connection', 'keep-alive');
        req.setHeader('Content-Length', '0');
        //String.valueOf(body.length())
        req.setHeader('Authorization',generateAuthorizationHeader());
       HttpResponse response = http.send(req);
        system.debug('Response----->'+response.getBody());
    }
    
    
    
    
    
    
}