public with sharing class ContactForm_Controller {
	
	public Contact theContact {public get; public set;}
	public String contactJson {public get; public set;}
	public Boolean renderPage {public get; public set;}

	 
 
	public class InvalidDataException extends Exception{}

	public ContactForm_Controller() {
		
		try{
			renderPage = true;
			String contactId = ApexPages.currentPage().getParameters().get('id');
			if (contactId !=null && contactId !=''){
				theContact = getContact(contactId);
				if (theContact == null || theContact.Id == null){
					throw new InvalidDataException('The provided contact Id is not valid');
				}else{
					contactJson = JSON.serialize(theContact);
				}
				
			}else {
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Contact Id is not provided'));
				renderPage = false;
			}

		}
		catch(Exception e) {
			System.debug('e ' + e.getMessage() + ' ' + e.getStackTraceString());
		    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
		    renderPage = false;
		}
	}

	public PageReference Save(){
		try{
			if (theContact !=null){
				update theContact;
				sendChatterFeed(theContact);
				return null;
			}
		}catch(Exception e){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage() + '@' + e.getStackTraceString() ));
			return null;
		}finally{
			return null;
		}
		 
		return null;
		
	}

	// another version of save just to demo how to save using action function in the Angular based page
	public PageReference Save2() {
		 
		try {
			Contact con = (Contact)JSON.deserialize(contactJson, Contact.class);
			update con;
			sendChatterFeed(con);
            return null;

		}catch (Exception e){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
			return null;
		}finally{
			return null;
		}

		return null;

	}

	public void sendChatterFeed(Contact thisContact) {
		String msg = 'Hello my name is ' + thisContact.FirstName + ' ' + thisContact.LastName + '. ' +
		             'My hobbies are: ' + thisContact.My_Hobbies__c;

		ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, 
			                                                                         thisContact.AccountId, 
			                                                                         ConnectApi.FeedElementType.FeedItem, 
			                                                                         msg);
	}


	private static Contact getContact(String contactId){
		List<Contact> contactList = new List<Contact>();
		contactList = [SELECT Id, AccountId, FirstName, LastName, My_Hobbies__c
		               FROM Contact
		               WHERE Id=:contactId];
		if (contactList !=null && contactList.size() >0){
			return contactList[0];
		}else{
			return new Contact();
		}		
	}
}