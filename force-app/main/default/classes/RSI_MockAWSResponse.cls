@isTest
global class RSI_MockAWSResponse implements HttpCalloutMock{
     global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://example.com/example/test', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        req.setEndpoint('https://lbs-cpq.s3.ap-south-1.amazonaws.com/2020/May/MyDocument.pdf');
        // Create a fake response
         String jsonResponse = '{"id":57,"name":"Beach and Mountain"}';
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
    }
}