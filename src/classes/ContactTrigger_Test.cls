@isTest
private class ContactTrigger_Test {
	
	private static Integer MAX_ACCOUNT_NUM = 5;
	private static Integer MAX_CONTACT_NUM = 200;

	@isTest static void insert_contact_test() {

		//--------------- setup test data ------------------
		List<Account> accountList = new List<Account>();
		List<Contact> contactList = new List<Contact>();

		for (Integer i=0; i<MAX_ACCOUNT_NUM; i++){
			String city = '';
			String country = '';
			String state = '';

			if (i<2) {
				city = 'Vancouver';
				country = 'Canada';
				state = 'BC';
			}
			else {
				city = 'Los Angeles';
				country = 'USA';
				state = 'CA';				
			}

			Account a = new Account();
			a.Name = 'Test_Account_' + i;
            a.BillingStreet = i + ' Main Street';
			a.BillingCity = city;
			a.BillingState = state;
			a.BillingCountry = country;
			a.BillingPostalCode = String.valueOf(i);

			accountList.add(a);
		}

		insert accountList;

		//since I only have 5 accounts in my test scope it is ok not to use a WHERE clause
		Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id,Name, BillingStreet,
		                                                           BillingCity, BillingState,BillingCountry,BillingPostalCode
		                                                    FROM Account]);

		Integer accountInx = -1;

		for (Integer i=0; i<MAX_CONTACT_NUM; i++){
			accountInx = accountInx + 1;
			if (accountInx == MAX_ACCOUNT_NUM){
				accountInx = 0;
			}
			 
			Account theAccount = accountList[accountInx];
			Contact c = new Contact();
			c.FirstName = 'Test FirstName ' + i;
			c.LastName = 'Test LastName ' + i;
			c.AccountId = theAccount.Id;

			contactList.add(c);
		}


		insert contactList;
		//--------------- end setup test data ----------------

		// since I only have 200 contacts in the scope it is ok not to use WHERE caluse here
		List<Contact> refreshedContactList = new List<Contact>([SELECT Id,AccountId,
			                                                           MailingStreet,MailingCity,MailingState,
			                                                           MailingCountry,MailingPostalCode
			                                                    FROM Contact]);
		Test.startTest();

		for (Contact theContact:refreshedContactList){
			Account theAccount = accountMap.get(theContact.AccountId);
						
			System.assertEquals(theContact.MailingStreet, theAccount.BillingStreet);
			System.assertEquals(theContact.MailingCity, theAccount.BillingCity);
			System.assertEquals(theContact.MailingState, theAccount.BillingState);
			System.assertEquals(theContact.MailingCountry, theAccount.BillingCountry);
			System.assertEquals(theContact.MailingPostalCode, theAccount.BillingPostalCode);
		}


		Test.stopTest();


	}
	
 
	
}