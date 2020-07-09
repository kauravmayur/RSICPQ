public class RSI_CPQ_QuoteToAWS implements Queueable, Database.AllowsCallouts {
    //Access Key ID:AKIAJX2STJSTACMF2JLQ
    //Secret Access Key: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
    //https://lbs-cpq.s3.ap-south-1.amazonaws.com/2020/May/Q-00005-20200605-0231.pdf
    //https://lbs-cpq.s3.ap-south-1.amazonaws.com/2020/May/0155w000003g6Z2AAI-Q-00005-20200605-0231.pdf
    public void execute(QueueableContext context){
        Document attach = [select Id, Body,ContentType,Name from Document where Name='Q-00005-20200605-0231.pdf'];
String attachmentBody = EncodingUtil.base64Encode(attach.Body);
system.debug('attachment body: '+attachmentBody);
String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
String key = 'AKIAJX2STJSTACMF2JLQ'; //AWS key
String secret = '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'; //AWS Secret key
String bucketname = 'lbs-cpq'; //AWS bucket name
String host = 's3.ap-south-1.amazonaws.com';
String method = 'PUT';
String filename = attach.Id + '-' + attach.Name;

HttpRequest req = new HttpRequest();
req.setMethod(method);
req.setEndpoint('https://' + bucketname + '.' + host + '/'+'2020/May/' + filename);
req.setHeader('Host', bucketname + '.' + host);
req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));
req.setHeader('Content-Encoding', 'UTF-8');
req.setHeader('Content-type', attach.ContentType);
req.setHeader('Connection', 'keep-alive');
req.setHeader('Date', formattedDateString);
req.setHeader('ACL', 'public-read-write');
req.setBodyAsBlob(attach.Body);

String stringToSign = 'PUT\n\n' + attach.ContentType + '\n' + formattedDateString + '\n' + '/' + bucketname + '/' + filename;
String encodedStringToSign = EncodingUtil.urlEncode(stringToSign, 'UTF-8');
Blob mac = Crypto.generateMac('HMACSHA256', blob.valueof(stringToSign),blob.valueof(secret));
String signedKey  = EncodingUtil.base64Encode(mac);
String authHeader = 'AWS' + ' ' + key + ':' + signedKey ;

req.setHeader('Authorization',authHeader);

String decoded = EncodingUtil.urlDecode(encodedStringToSign , 'UTF-8');

Http http = new Http();
HTTPResponse res = http.send(req);
List<String> getHeaderdKeys = res.getHeaderKeys();
        system.debug('header keys: '+getHeaderdKeys);
        
    }
    public static string getHTMLEncodedVals (String strInput) {
        strInput = strInput.replace(' ', '%20');
        strInput = strInput.replace('\'', '%27');
        return strInput;
    }

    
}