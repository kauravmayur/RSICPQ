public class AWSS3_GetService extends Test_RSI_QuoteToAWS{
    public override void init() {
            resource = '/';
            region = 'ap-south-1';
            service = 's3';
            //endpoint = new Url('https://' + service + '.' + region + '.amazonaws.com/');
            endpoint = new Url('https://' + service + '.amazonaws.com/');
            accessKey = 'AKIAJAMYPYEJS3IN24QA';
            method = HttpMethod.XGET;
            //	Remember to set "payload" here if you need to specify a body
            //	payload = Blob.valueOf('some-text-i-want-to-send');
            //  This method helps prevent leaking secret key, 
            //  as it is never serialized
            createSigningKey('BheqDpaJjby5Pk0QcHd1oTgrIqIwq7RmgKXKp2uL');
       }
       public List<String> getBuckets() {
           HttpResponse response = sendRequest();
           List<String> results = new List<String>();
           // Read response XML; if we get this far, no exception happened
           // This code was omitted for brevity
           return results;
       }

}