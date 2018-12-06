public with sharing class DocuSignDemoController {
	public String customerName {get; set;}

	static String hostUserName = 'masoud.azampour@gmail.com';
	static String password = 'Thisisnew1';
	static String docuSignAccountId = '8b13e2e5-ec16-4b30-9c07-bb675275ae70';
	static String integratorKey = 'b01262b6-5a10-42f7-b39f-7904a47a6a98';
	static String envCreateUrl = 'https://demo.docusign.net/restapi/v2/accounts/#accountid#/envelopes';

	static String baseUrl = 'https://demo.docusign.net/restapi/v2/accounts/' + docuSignAccountId + '/envelopes';

	static String authJson = '{"Username":"' + hostUserName + '","Password":"' + password + '","IntegratorKey": "' + integratorKey + '"}';

	static String templateId = 'a8f4175e-d5f8-4f7a-a454-90e6ff6b9384';

	//---------------------------------------------------------------------------------//

    private static String DSAccountId = '8b13e2e5-ec16-4b30-9c07-bb675275ae70';
    private static String DSUsername = 'masoud.azampour@gmail.com';
    private static String DSPassword = 'Thisisnew1';
    private static String DSIntegratorKey = 'b01262b6-5a10-42f7-b39f-7904a47a6a98';
    private static String DSBaseUrl = 'https://demo.docusign.net/restapi/v2/8b13e2e5-ec16-4b30-9c07-bb675275ae70';
    private static String DSInitialUrl = 'https://demo.docusign.net/restapi/v2/login_information';

	public class SendHTTPRequestException extends Exception { }

	public DocuSignDemoController() {
		
	}




	public PageReference showSigingPage() {
		return null;
	}

    public static HttpRequest initRequest() {
        HttpRequest req = new HttpRequest();
        req.setHeader('X-DocuSign-Authentication', '{"Username":"' + DSUsername + '","Password":"' + DSPassword + '","IntegratorKey":"' + DSIntegratorKey + '"}');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/xml');
        return req;     
    }


    public static String initializeDS() {
        Http h = new Http();

        HttpRequest req = initRequest();
        req.setEndpoint(DSInitialUrl);
        req.setMethod('GET');

        HttpResponse res = h.send(req);

        Dom.Document doc = new Dom.Document();         
        doc.load(res.getBody());
        System.debug(res.getBody());

        Dom.XMLNode root = doc.getRootElement().getChildElements()[0].getChildElements()[0];

       	System.debug('root ' + root);

        for(integer i=0; i < root.getChildElements().size();i++) {
            Dom.XMLNode dsSetting = root.getChildElements()[i];

            System.debug('dsSetting ' + dsSetting.getName());

            if(dsSetting.getName() == 'baseUrl') DSBaseUrl = dsSetting.getText();
            if(dsSetting.getName() == 'accountId') DSAccountId = dsSetting.getText();
        }

        return '';
    }


	public static void sendTestRequest() {
    	String url = 'https://account-d.docusign.com/oauth/auth?response_type=code&scope=signature%20impersonation&client_id=b01262b6-5a10-42f7-b39f-7904a47a6a98&redirect_uri=https://login.salesforce.com';
    	//'https://account-d.docusign.com/oauth/token?grant_type=password&client_id=b01262b6-5a10-42f7-b39f-7904a47a6a98&username=masoud.azampour@gmail.com&password=Thisisnew1&scope=all';
    	String method = 'GET';

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod(method);

       //req.setHeader('Content-Type', requestContentTypes);
        req.setEndpoint(url);
        //req.setBody(body);
        req.setTimeout(120000);



        HttpResponse res = h.send(req);

        System.debug('res ' + res);
        System.debug(res.getBody());
        System.debug(res.getStatus());		
	}


    public static void sendTemplateTestRequest() {
    	String url = baseUrl;
    	    	
    	String method = 'POST';

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod(method);

        req.setHeader('X-DocuSign-Authentication', authJson);
        req.setHeader('Content-Type', 'application/json');
        
        req.setEndpoint(url);

        String body = '{' + '"templateId"' + ':' + '"' + templateId + '"}'; 
        req.setBody(body);
        
        req.setTimeout(120000);



        HttpResponse res = h.send(req);

        System.debug('res ' + res);
        System.debug(res.getBody());
        System.debug(res.getStatus());

        Object o =  JSON.serialize(res.getBody());

        String pdfUrl = '';

        // Parse JSON response to get all the totalPrice field values.
        JSONParser parser = JSON.createParser(res.getBody());
       
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'uri')) {
                	// Get the value.
                	parser.nextToken();
  					pdfUrl = parser.getText();

            }
        }

        System.debug('pdfUrl ' + pdfUrl);

    }

    public PageReference redirect() {
    	PageReference pageRef = new PageReference('https://account-d.docusign.com/oauth/auth?response_type=code&scope=signature%20impersonation&client_id=b01262b6-5a10-42f7-b39f-7904a47a6a98&redirect_uri=https://masoud-dev-ed--c.na50.visual.force.com/apex/DocuSignDemo');
    	return pageRef;
    }









	public static HttpResponse sendHTTPRequest(String httpMethod, String body, String url, 
		                                       String authToken, String requestContentTypes, String responseContentTypes)
    {
    	//guard conditions:
        if (httpMethod == null || httpMethod == '' ||
        	body == null || body == '' ||
        	url == null || url == '' ||
        	requestContentTypes == null || requestContentTypes == '')
       	{
       		throw new SendHTTPRequestException('Invalid exception paramaters for HTTP callout.');
       	}

        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setMethod(httpMethod);

        if (authToken != null || responseContentTypes == '')
        {
        	req.setHeader('Authorization', 'Bearer ' + authToken);
       	}
       	if (responseContentTypes != null || responseContentTypes == '')
       	{
        	req.setHeader('Accept', responseContentTypes);
        }

        req.setHeader('Content-Type', requestContentTypes);
        req.setEndpoint(url);
        req.setBody(body);
        req.setTimeout(120000);

        HttpResponse res = h.send(req);
        
        return res;
    }
}