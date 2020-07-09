public class RSI_S3_servicetest {
    //This method returns GMT time.
    //Document doc = [SELECT Body,Name, Id FROM Document WHERE Id = '0155w000003g503AAA'];
    Document doc = new Document();
    public static String generatedTime() {
        String currentDateOnly = DateTime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        return currentDateOnly;
    }
    
    
    //This method generates canonical request.
    public static string generatedCanonicalRequest() {
    String canonicalRequest = '';
           canonicalRequest += 'PUT'+'\n';     
           canonicalRequest += generateURI('lbs-cpq','s3','ap-south-1','0155w000003g503AAA')+'\n';
           canonicalRequest += getCanonicalHeaders(generateHeaders())+'\n';
           canonicalRequest += getSignedHeaders(generateHeaders())+'\n';
           canonicalRequest += generatePayload(); 
    system.debug(canonicalRequest);
                                                       
    return canonicalRequest;    
    }
	
    
    //This method generates the canonical headers and their values in lowercase.
    //https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html#canonical-request
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
        String payload = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256',Blob.valueOf('')));
        //String payload = string.valueOf(b);
        return payload;
    }
    //document to be uploaded.
    public static string generateFileName(String documentId) {
        Document doc = [SELECT Body,Name, Id FROM Document WHERE Id = :documentId];
        String fileName = getHTMLEncodedVals('2020/May' + '/' + doc.Name);
        return fileName;
    }
    public static string getHTMLEncodedVals (String strInput) {
        strInput = strInput.replace(' ', '%20');
        strInput = strInput.replace('\'', '%27');
        return strInput;
    }
    
    //This methods give the encoded URI.
    //https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_encodingUtil.htm
    public static String generateURI(String bucket, String service, String region, String documentId) {
        String url = 'https://'+bucket+'.'+service+'.'+region+'.'+'amazonaws.com/'+ generateFileName(documentId);
        String encodedURL = EncodingUtil.urlEncode(url, 'UTF-8');
        //system.debug('Encoded URL---->'+url);
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
        generateHeaders.put('Content-Length', '');
        return generateHeaders;
    }


}