@isTest
private class ContactForm_Controller_Test {
	
	@isTest static void test_save() {
		Account a = new Account();
		a.Name = 'Test Account';
		insert a;

		Contact c = new Contact();
		c.FirstName = 'John';
		c.LastName = 'Smith';
		insert c;

		PageReference contactPage = Page.ContactForm;
		Test.setCurrentPage(contactPage);
		
		ApexPages.currentPage().getParameters().put('id', c.Id);
		 
		Test.startTest();
		ContactForm_Controller ctrl = new ContactForm_Controller();
		System.debug(ctrl);
		Contact con1 = ctrl.theContact;
	
		con1.My_Hobbies__c = 'Reading';
		ctrl.Save();

		Contact resultCon = [SELECT Id,My_Hobbies__c FROM Contact Where Id=:c.Id];

		System.assertEquals(resultCon.My_Hobbies__c, 'Reading');
		Test.stopTest(); 
	}
	
	@isTest static void test_save2() {
		Account a = new Account();
		a.Name = 'Test Account';
		insert a;

		Contact c = new Contact();
		c.FirstName = 'John';
		c.LastName = 'Smith';
		insert c;

		PageReference contactPage = Page.ContactFormAng;
		Test.setCurrentPage(contactPage);
		
		ApexPages.currentPage().getParameters().put('id', c.Id);
		 
		Test.startTest();
		ContactForm_Controller ctrl = new ContactForm_Controller();
		System.debug(ctrl);
		Contact con1 = ctrl.theContact;
		
		con1.My_Hobbies__c = 'Reading';
		ctrl.contactJson = JSON.serialize(con1);
		ctrl.Save2();

		Contact resultCon = [SELECT Id,My_Hobbies__c FROM Contact Where Id=:c.Id];

		System.assertEquals(resultCon.My_Hobbies__c, 'Reading');
		Test.stopTest(); 
	}

	//only to cover exception
	@isTest static void test_excep1_noId() {
		PageReference contactPage = Page.ContactFormAng;
		Test.setCurrentPage(contactPage);
		ApexPages.currentPage().getParameters().put('id', '');
		
		Test.startTest();
		ContactForm_Controller ctrl = new ContactForm_Controller();
		System.assertEquals(ctrl.renderPage, false);
		Test.stopTest();

	}

	//only to cover exception
	@isTest static void test_excep1_badFormat() {
		PageReference contactPage = Page.ContactFormAng;
		Test.setCurrentPage(contactPage);
		ApexPages.currentPage().getParameters().put('id', '0030000000xx');
		
		Test.startTest();
		ContactForm_Controller ctrl = new ContactForm_Controller();
		System.assertEquals(ctrl.renderPage, false);
		Test.stopTest();

	}
	
}