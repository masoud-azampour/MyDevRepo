public without sharing class ContactTriggerService {
    public static Integer i = 0;
	public static void copyMailingAddressFromAccountBilling(List<Contact> contactList) {
		Set<Id> accountIdSet = new Set<Id>();
		
		for (Contact theContact:contactList) {
			if (theContact.AccountId !=null) {
				accountIdSet.add(theContact.AccountId);
			}
		}

		if (accountIdSet.size() > 0){
			Map<Id, Account> idToAccountMap = new Map<Id, Account>([SELECT Id, Name, BillingStreet,
				                                                           BillingCity, BillingState,
				                                                           BillingCountry, BillingPostalCode
				                                                    FROM   Account
				                                                    WHERE  Id IN:accountIdSet]);

			if (idToAccountMap !=null && idToAccountMap.size() >0){
				for (Contact theContact:contactList) { 
					if (theContact.AccountId !=null) {
						Account theAccount = idToAccountMap.get(theContact.AccountId);
						
						theContact.MailingStreet = theAccount.BillingStreet;
						theContact.MailingCity = theAccount.BillingCity;
						theContact.MailingState = theAccount.BillingState;
						theContact.MailingCountry = theAccount.BillingCountry;
						theContact.MailingPostalCode = theAccount.BillingPostalCode;
					}	
				}
			}
		}
	}
}