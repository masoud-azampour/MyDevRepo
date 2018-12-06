public without sharing class CreditCardController {
	
	public static String SANDBOX_END_POINT = 'https://apitest.authorize.net/xml/v1/request.api';
	
	@AuraEnabled
	public static String processPayment(Decimal amount, String transRefNumber, String poNumber, 
										String cardNumber, String cvv, String expMonth, String expYear,
	                                    String cutomerId ,String firstName, String lastName, String email, String nameOnCard) {
	    
	    String result = '';	
	    try	{                        	
		
		
			String jsonBody = buildJsonRequest(amount, transRefNumber, poNumber, cardNumber, cvv, expMonth, expYear,
		                                       cutomerId, firstName, lastName, email, nameOnCard); 
		                                       
		    String url = SANDBOX_END_POINT;
			
			Http h = new Http();
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setBody(jsonBody);
			req.setHeader('Content-Type', 'application/json');
			req.setEndpoint(url);
			req.setTimeout(120000);
			HttpResponse res = h.send(req);
			System.debug(res);
			System.debug(res.getBody());
			
			result = res.getStatus() + '|' + res.getBody(); 
				
	    } catch (Exception ex){
	    	result = 'Error: ' + ex.getMessage();
	    }
		return result;
		
		
	}
	
	public static String buildJsonRequest(Decimal amount, String transRefNumber, String poNumber, 
										  String cardNumber, String cvv, String expMonth, String expYear,
	                                      String cutomerId ,String firstName, String lastName, String email, String nameOnCard) {
	    
	    String strRequestBody = 
	    
		'{' + 
		'	"createTransactionRequest" : {' + 
		'		"merchantAuthentication" : {' + 
		'			"name" : "3NDCf8e6c",' + 
		'			"transactionKey" : "8Q35Xy75Jrp68Gqg"' + 
		'		},' + 
		'		"refId" : "' + transRefNumber + '",' + 
		'		"transactionRequest" : {' + 
		'			"transactionType" : "authCaptureTransaction",' + 
		'			"amount" : "' + String.valueOf(amount) + '",' + 
		'			"payment" : {' + 
		'				"creditCard" : {' + 
		'					"cardNumber" : "' + cardNumber + '",' + 
		'					"expirationDate" : "' + expMonth + expYear + '",' + 
		'					"cardCode" : "' + cvv + '"' + 
		'				}' + 
		'			},' + 
		'			"lineItems" : {' + 
		'				"lineItem" : {' + 
		'					"itemId" : "1",' + 
		'					"name" : "vase",' + 
		'					"description" : "Cannes logo",' + 
		'					"quantity" : "18",' + 
		'					"unitPrice" : "45.00"' + 
		'				}' + 
		'			},' +  
		'			"poNumber" : "' + poNumber + '",' + 
		'			"customer" : {' + 
		'				"id" : "' + cutomerId + '",' +
		'               "email" : "' + email + '"' +  
		'			},' + 
		'			"transactionSettings" : {' + 
		'				"setting" : {' + 
		'					"settingName" : "testRequest",' + 
		'					"settingValue" : "false"' + 
		'				}' + 
		'			}' + 
		'		}' + 
		'	}' + 
		'}';
	    
	    return strRequestBody;
		
	}
	
	

	
}