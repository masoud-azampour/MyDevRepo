public without sharing class OppRenewalController {
	
    public class PageData 
    {
        @AuraEnabled
        public User currentUser;

        
        @AuraEnabled 
        public List<Opportunity> opps;

        
        public PageData() 
        {
            this.currentUser = getCurrentUser();
            this.opps = null;
            
            if (this.currentUser !=null && this.currentUser.ContactId !=null) {
            	Set<String> oppIds = getContactsOppIds(this.currentUser.ContactId);
            	
            	if (oppIds !=null && oppIds.size() > 0) {
            		this.opps = getOpportunities(oppIds);
            	}
            }
        }
                
    }

    
    
    @AuraEnabled
    public static PageData getPageData()
    {       
        return new PageData();
    }
	
    public static User getCurrentUser() {
        List<User> users 
            = [SELECT Id, UserName, Name, 
                      ContactId, Contact.AccountId, Contact.Email, Contact.FirstName, Contact.LastName,
                      Contact.Account.Name, Contact.Account.AccountNumber
                      
                FROM User
                WHERE Id =: UserInfo.getUserId()];

        return users.isEmpty() ? null : users[0];
    }
    
    //  get the oppids for the contact in which he is the primary contact
    // and the opp close date is between last year and next year
    public static Set<String> getContactsOppIds(String conId) {
    	Set<String> oppIds = new Set<String>(); //
    	List<OpportunityContactRole> oppContactRoleList =
    		 new List<OpportunityContactRole>([Select OpportunityId
    		 								   From OpportunityContactRole 
    		 								   Where ContactId =: conId
    		 								        and IsPrimary = true
    		 								        and Opportunity.CloseDate >= LAST_YEAR
    		 								        and Opportunity.CloseDate <= NEXT_YEAR]);
    		 								        
    	if (oppContactRoleList.size() > 0){
    		for (OpportunityContactRole ocr:oppContactRoleList){
    			oppIds.add(ocr.OpportunityId);
    		}
    	} 
    	
    	return oppIds;
    }
    
    
    public static List<Opportunity> getOpportunities(Set<String> oppIds){
    	
    	List<Opportunity> result = new List<Opportunity>();
    	
    	result = [Select Id, Name, Closedate, Isclosed, AccountId, Account.Name, Amount,  
       				     Renewal_date__c, stagename,
       				     (Select PricebookEntry.ProductCode, PricebookEntry.Product2Id, PricebookEntry.Product2.Name,  
       						     PricebookEntry.Product2.Description,
                                 Quantity, UnitPrice,  ListPrice, Discount, TotalPrice
                          From OpportunityLineItems)
       			  From Opportunity 
       			  Where Id IN :oppIds
       			  Order By Closedate ASC]; 
    	
    	return result;
    }
   
}