public without sharing class InvoiceDetailController {
   
   	public  Invoice__c theInvoice {public get; private set;}

	public  List<Invoice_Line_Item__c> invoiceLineItemList {public get; public set;}

	public String invoiceId {public get; public set;}

	public Boolean showInvLines {public get; private set;}

	public class InvoiceLinesPageException extends Exception {}

    public InvoiceDetailController() {

    	try {
	    	showInvLines = false;
	     	
	     	invoiceId = ApexPages.currentPage().getParameters().get('id');
	     	
	     	if (invoiceId !=null && invoiceId !='') {
	     		setInvoiceLineItems(invoiceId);

	     		if (theInvoice !=null && theInvoice.Id !=null) {
	     			showInvLines = true;
	     		}

	     	} else {
				throw new InvoiceLinesPageException('Invoice Id parameter is not provided');
	     	}

     	} catch (Exception e) {
     		ApexPages.addMessages(e);
     	}

    }


    public void deleteRow() {
		try {		
 
			Integer rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
			
			System.debug('rowbe deleted ' + rowIndex );
			
			Invoice_Line_Item__c lineItemToDel =  invoiceLineItemList.remove(rowIndex);
			
			if (lineItemToDel.Id !=null) {
				delete lineItemToDel;
			}

			refreshInvoiceLines();
			
			System.debug('lineItemToDel ' + lineItemToDel);
		} catch (Exception e){
			System.debug(e);
			ApexPages.addMessages(e);
		}
    }

	public void addLineItemRow() {
		if (theInvoice !=null && theInvoice.Id !=null) {
			Invoice_Line_Item__c invLine = new Invoice_Line_Item__c(Invoice__c = theInvoice.Id);
			invoiceLineItemList.add(invLine);
		}
	}

	public void refreshInvoiceLines() {
		if (invoiceId !=null && invoiceId !='') {
			setInvoiceLineItems(invoiceId);
		}
	}

    public PageReference save() {

    	System.debug('invoiceLineItemList**** ' + invoiceLineItemList); 

        try {
            if (invoiceLineItemList !=null && invoiceLineItemList.size() >0) {
				upsert invoiceLineItemList;
				refreshInvoiceLines();
			}
        } catch(Exception e) {
            ApexPages.addMessages(e);
            return null;
        }
        
        return null;
    }

	 public PageReference cancel() {

	 	  if (theInvoice !=null && theInvoice.Id !=null) {
		      PageReference retURL = new PageReference('/' + theInvoice.Id );
		      retURL.setRedirect(true);
		      return retURL;
	  	  } else {
	  	  	return null;
	  	  }

	 }

    private void setInvoiceLineItems(String invId) {
    	theInvoice = new Invoice__c();
    	invoiceLineItemList = new List<Invoice_Line_Item__c>();

    	
		List<Invoice__c> invList = new List<Invoice__c>();

		invList = [SELECT Id, Name, 
		                 Account__c, PO_Number__c, Account__r.Name,
		                 Sales_Rep__c, Total__c, Sales_Rep__r.Name,
		                 Transaction_Date__c, Type__c,
		                 (SELECT Id, Name, Invoice__c,
		                         Product__c, Product__r.Name,
		                         Quantity__c, Sales_Price__c,
		                         Total__c, Type__c, Notes__c
		                  FROM  Invoice_Line_Items__r
		                 )
		          FROM Invoice__c
		          WHERE Id =: invId];

		if (invList.size() > 0) {
			theInvoice = invList[0];

			if (theInvoice.Invoice_Line_Items__r.size() >0) {
				invoiceLineItemList = theInvoice.Invoice_Line_Items__r;
			}

		} else {
			throw new InvoiceLinesPageException('Invalid invoice Id. Could not find the invoice');
		}
    	
    }
}