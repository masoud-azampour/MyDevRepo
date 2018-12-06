public with sharing class WorkorderController {
	
	//https://prats23.wordpress.com/2014/04/27/salesforce-dynamically-addingdeleting-rows-in-visualforce/
	
	public  Workorder theWorkOrder {public get; private set;}

	public  List<WorkOrderLineItem> workOrderLineItemList {public get; public set;}

	public Boolean canAddWoLines {public get; private set;}

	public WorkorderController() {
 
		String workOrderId = ApexPages.currentPage().getParameters().get('id');

		if (workOrderId !=null && workOrderId !='') {
			setWorkOrderAndWorkOrderLines(workOrderId);

			if (theWorkOrder !=null && theWorkOrder.Id !=null) {
				canAddWoLines = true;
			} else {
				canAddWoLines = false;
			}

		} else {
			canAddWoLines = false;
		}

		System.debug('theWorkOrder---- ' + theWorkOrder);
		
	}
 
	public void addNewWorkLineItemRow() {
		if (theWorkOrder !=null && theWorkOrder.Id !=null) {
			WorkOrderLineItem woLine = new WorkOrderLineItem(WorkorderId = theWorkOrder.Id);
			workOrderLineItemList.add(woLine);
		}
	}
	
	public void deleteRow() {
		try {		
			String woLineId = ApexPages.currentPage().getParameters().get('woLineId');
			if (woLineId == null) {
				woLineId ='';
			}
			Integer rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
			
			System.debug('rowbe deleted ' + rowIndex );
			System.debug('woLineId ' + woLineId );
			
			WorkOrderLineItem woLineItemToDel =  workOrderLineItemList.remove(rowIndex);
			
			if (woLineItemToDel.Id !=null) {
				delete woLineItemToDel;
			}
			
			System.debug('woLineItemToDel ' + woLineItemToDel);
		} catch (Exception e){
			ApexPages.addMessages(e);
		}
	}

    public PageReference save() {

    	System.debug('theWorkOrder**** ' + theWorkOrder); 

        try {
            upsert(theWorkOrder);
            if (workOrderLineItemList !=null && workOrderLineItemList.size() >0) {
				upsert workOrderLineItemList;
			}
        } catch(Exception e) {
            ApexPages.addMessages(e);
            return null;
        }
        
        return null;
    }

	private void setWorkOrderAndWorkOrderLines(String workOrderId) {
		theWorkOrder = new Workorder();
		workOrderLineItemList = new List<WorkOrderLineItem>();
		
		if (workOrderId !=null && workOrderId !=''){
			List<Workorder> woList = new List<Workorder>();
			woList = [SELECT Id, WorkOrderNumber, AccountId, Account.Name, AssetId, CaseId,
			                 ContactId, Contact.FirstName, Contact.LastName,
			                 Description, Subject, StartDate, EndDate,Status,
			                 (SELECT Id, WO_Code__c, Description, StartDate, EndDate, 
			                         Status,Subject
			                  FROM WorkOrderLineItems 
			                 )
			          FROM Workorder
			          WHERE Id =: workOrderId];

			if (woList !=null && woList.size() >0) {
				theWorkOrder = woList[0];

				if (theWorkOrder.WorkOrderLineItems.size() > 0) {
					workOrderLineItemList = theWorkOrder.WorkOrderLineItems;
				}
			} 
		}
	}
}