public class Fresh_AWS_s3 {
    public static void createCanonicalRequest(String httpMethod, String canonicalURI ) {
        
    }
    //This methods sorts the headers and converts them to lower case.
    public static String createSignedHeaders(Map<String , String> headers) {
        List<String> sortedHeaders = new List<String>();
        sortedHeaders.addAll(headers.keySet());
        sortedHeaders.sort();
        String buffer = '';
        for(String header : sortedHeaders) {
            if(buffer.length()>0) buffer += ';';
            buffer += header.toLowerCase();
        }
        system.debug(buffer);
        return buffer;
    }
    
    public static String createCanonicalHeaders(Map<String , String> headers) {
        system.debug('Map-->'+headers);
        List<String> sortedHeader = new List<String>();
        sortedHeader.addAll(headers.keySet());
        sortedHeader.sort();
        system.debug('sorted header-->'+sortedHeader);
        String canonicalHeader='';
        for(String sortedkeys : sortedHeader) {
            if(canonicalHeader.length()>0) //canonicalHeader += ':';
            canonicalHeader += sortedkeys.toLowerCase() + ':'+ headers.get(sortedkeys) + '\n';
        }
        system.debug(canonicalHeader);
        return canonicalHeader;
    }
    
    public static void createSignedHeaders() {
        
    }

}