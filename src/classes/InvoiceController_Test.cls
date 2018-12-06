@isTest
private class InvoiceController_Test {

	private static Invoice__c testInvoice;

	private static List<Invoice_Line_Item__c> testInvLines;
	
	@isTest static void getInvoiceDetails_Test() {
		setupTestData();

		PageReference invPage = Page.Editinvoicedetails;
		Test.setCurrentPage(invPage);
		Apexpages.currentPage().getParameters().put('id' , testInvoice.Id);

		Test.startTest();
		InvoiceDetailController ctrl = new InvoiceDetailController();
		System.assert(ctrl.invoiceLineItemList !=null 
			          && ctrl.invoiceLineItemList.size() == 2);
		Test.stopTest();
	}
	
	//Invalid invoice Id. Could not find the invoice
	@isTest static void badId_Test() {
		PageReference invPage = Page.Editinvoicedetails;
		Test.setCurrentPage(invPage);
		Apexpages.currentPage().getParameters().put('id' , 'a7363898'); 

		Test.startTest();
		String theErrorMsg = '';
		InvoiceDetailController ctrl = new InvoiceDetailController();
		List<Apexpages.Message> msgs = ApexPages.getMessages();
		for (Apexpages.Message msg:msgs) {
			if (msg.getDetail().contains('Invalid invoice Id. Could not find the invoice')) {
				theErrorMsg = 'Invalid invoice Id. Could not find the invoice';
			}
		}

		System.assertEquals(theErrorMsg, 'Invalid invoice Id. Could not find the invoice');

		Test.stopTest();
	}

	//Invoice Id parameter is not provided
	@isTest static void noId_Test() {
		PageReference invPage = Page.Editinvoicedetails;
		Test.setCurrentPage(invPage);
		
		Test.startTest();
		String theErrorMsg = '';
		InvoiceDetailController ctrl = new InvoiceDetailController();
		List<Apexpages.Message> msgs = ApexPages.getMessages();
		for (Apexpages.Message msg:msgs) {
			if (msg.getDetail().contains('Invoice Id parameter is not provided')) {
				theErrorMsg = 'Invoice Id parameter is not provided';
			}
		}

		System.assertEquals(theErrorMsg, 'Invoice Id parameter is not provided');

		Test.stopTest();
	}

	@isTest static void cancel_Test() {
		Account a = new Account();
		a.Name = 'Test Account';
		insert a;	

		Invoice__c inv = new Invoice__c();
		inv.Account__c = a.Id;
		inv.Sales_Rep__c = UserInfo.getUserId();
		inv.Transaction_Date__c = Date.today();
		inv.Type__c = 'Fulfillment';
		insert inv;

		PageReference invPage = Page.Editinvoicedetails;
		Test.setCurrentPage(invPage);
		Apexpages.currentPage().getParameters().put('id' , inv.Id);
		InvoiceDetailController ctrl = new InvoiceDetailController();

		Test.startTest();
		PageReference  pageRef = ctrl.cancel();
		System.assert(pageRef.getUrl().contains(String.valueOf(inv.Id)));
		Test.stopTest();

	}

	@isTest static void editAndDeleteExsitingLine() {
		setupTestData();

		PageReference invPage = Page.Editinvoicedetails;
		Test.setCurrentPage(invPage);
		Apexpages.currentPage().getParameters().put('id' , testInvoice.Id);

		Test.startTest();
		InvoiceDetailController ctrl = new InvoiceDetailController();
		
		//Edit first row
		ctrl.invoiceLineItemList[0].Quantity__c = 2;
		ctrl.save();

		//Delete second row
		Apexpages.currentPage().getParameters().put('rowIndex' , '1');
		ctrl.deleteRow();

		ctrl.refreshInvoiceLines();

		System.assertEquals(ctrl.invoiceLineItemList.size() , 1);
		System.assertEquals(ctrl.theInvoice.Total__c, 400);

		Test.stopTest();

	}

	@isTest static void addNewLineOk() {
		setupTestData();
		Product2 p3 = new Product2();
		p3.Name = 'test prod 3';
		insert p3;

		PageReference invPage = Page.Editinvoicedetails;
		Test.setCurrentPage(invPage);
		Apexpages.currentPage().getParameters().put('id' , testInvoice.Id);	
		
		Test.startTest();
		InvoiceDetailController ctrl = new InvoiceDetailController();
		
		ctrl.addLineItemRow(); //now we have 3 line items

		ctrl.invoiceLineItemList[2].Sales_Price__c = 400;
		ctrl.invoiceLineItemList[2].Quantity__c = 1;
		ctrl.invoiceLineItemList[2].Product__c = p3.Id;

		ctrl.save();

		ctrl.refreshInvoiceLines();
		System.assertEquals(ctrl.theInvoice.Total__c, 700);


		Test.stopTest();
	}

	@isTest static void addNewLineBadData1() {
		setupTestData();
		PageReference invPage = Page.Editinvoicedetails;
		Test.setCurrentPage(invPage);
		Apexpages.currentPage().getParameters().put('id' , testInvoice.Id);
		
		String theErrorMsg = '';
		Test.startTest();
		InvoiceDetailController ctrl = new InvoiceDetailController();
		ctrl.addLineItemRow(); //Sales Price: You must enter a value
		ctrl.save();
		List<Apexpages.Message> msgs = ApexPages.getMessages();
		for (Apexpages.Message msg:msgs) {
			theErrorMsg =  theErrorMsg + msg.getDetail();
		}
		 
		System.assert(theErrorMsg.containsIgnoreCase('Sales Price: You must enter a value') 
					  || theErrorMsg.containsIgnoreCase('Quantity: You must enter a value')
					  || theErrorMsg.containsIgnoreCase('Product, Quantity and Sales Price are required'));

		Test.stopTest();
	}

	@isTest static void addNewLineBadData2() {
		setupTestData();
		Product2 p3 = new Product2();
		p3.Name = 'test prod 3';
		insert p3;

		PageReference invPage = Page.Editinvoicedetails;
		Test.setCurrentPage(invPage);
		Apexpages.currentPage().getParameters().put('id' , testInvoice.Id);
		
		String theErrorMsg = '';
		Test.startTest();
		InvoiceDetailController ctrl = new InvoiceDetailController();
		ctrl.addLineItemRow(); //Sales Price: You must enter a value
		ctrl.invoiceLineItemList[2].Sales_Price__c = 400;
		ctrl.invoiceLineItemList[2].Quantity__c = 0;
		ctrl.invoiceLineItemList[2].Product__c = p3.Id;
		ctrl.save();
		List<Apexpages.Message> msgs = ApexPages.getMessages();
		for (Apexpages.Message msg:msgs) {
			theErrorMsg =  theErrorMsg + msg.getDetail();
		}

		System.assert(theErrorMsg.containsIgnoreCase('Quantity has to be greater than zero'));

		Test.stopTest();
	}



	// Helper method to create test inv and inv lines
	private static void setupTestData() {
		Account a = new Account();
		a.Name = 'Test Account';
		insert a;

		List<Product2> prodList = new List<Product2>();

		Product2 p1 = new Product2();
		p1.Name = 'test prod 1';

		Product2 p2 = new Product2();
		p2.Name = 'test prod 2';

		prodList.add(p1);
		prodList.add(p2);

		insert prodList;


		Invoice__c inv = new Invoice__c();
		inv.Account__c = a.Id;
		inv.Sales_Rep__c = UserInfo.getUserId();
		inv.Transaction_Date__c = Date.today();
		inv.Type__c = 'Fulfillment';
		insert inv;

		List<Invoice_Line_Item__c> invLineList = new List<Invoice_Line_Item__c>();

		Invoice_Line_Item__c invLine1 = new Invoice_Line_Item__c(Invoice__c = inv.Id);
		invLine1.Product__c = p1.Id;
		invLine1.Quantity__c = 1;
		invLine1.Sales_Price__c = 200;
		invLine1.Type__c = 'Software';
		invLine1.Notes__c = 'test note';
		invLineList.add(invLine1);

		Invoice_Line_Item__c invLine2 = new Invoice_Line_Item__c(Invoice__c = inv.Id);
		invLine2.Product__c = p2.Id;
		invLine2.Quantity__c = 1;
		invLine2.Sales_Price__c = 100;
		invLine2.Type__c = 'Software';
		invLineList.add(invLine2);

		insert invLineList;

		testInvoice = inv;
		testInvLines = invLineList;
	}
}