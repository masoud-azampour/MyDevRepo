trigger AccountTrigger on Account (after insert,after update) {
    
    System.debug('0');
    
    if (trigger.isInsert){
    
        List<Project__c> projList = new List<Project__c>();
        
        List<Contact> conList = new List<Contact>();
        
        Set<Id> accIds = new Set<Id>();
    
        for (Account a:trigger.new){  //List<Account>  
           Project__c theProject = new Project__c();
           theProject.Account__c = a.Id;
           theProject.Start_Date__c = Date.today();
           theProject.End_Date__c = Date.today().addDays(365);
           theProject.Description__c = 'First default project';
           thePRoject.Name = a.Name + ' ' + '100';
           //insert thePRoject;
           projList.add(thePRoject);
           accIds.add(a.Id);
        }
        
        conList = [Select Id,FirstName,LastName From Contact Where AccountId IN: accIds];
        
        if (projList.size() > 0){
            insert projList;
        }
    }
    
    if (trigger.isUpdate){
    }
}