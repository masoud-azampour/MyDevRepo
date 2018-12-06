public with sharing class ContactTrigger {
	
	public void execute(){
		
		if (trigger.isInsert && trigger.isBefore && 
			trigger.new !=null && trigger.new.size() >0) {
			 
			List<Contact> contactList = (List<Contact>) trigger.new;
			ContactTriggerService.copyMailingAddressFromAccountBilling(contactList);
		}
	}
}