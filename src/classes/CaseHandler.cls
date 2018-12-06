/**
 * Domain/Handler class for Case SObject
 */

public with sharing class CaseHandler extends TriggerHandlerBase {
    public override void handleBeforeInsert() {
         System.debug('In handleBeforeInsert() method in CaseHandler');
    }

    public override void handleBeforeUpdate() {
        System.debug('In handleBeforeUpdate() method in CaseHandler');
    }

    public override void handleBeforeDelete(){

    }

    public override void handleAfterInsert() {
         System.debug('In handleAfterInsert() method in CaseHandler');

    }

    public override void handleAfterUpdate(){
    
        System.debug('In handleAfterUpdate() method in CaseHandler');
        System.debug('Calling CaseHelper.doLogCaseChanges');
        // helper class or service class to run business logic 
        CaseHelper.doLogCaseChanges((Map<Id, Case>) oldRecordsMap, (List<Case>) newRecordsList);
    }

    public override void handleAfterDelete() {

    }

    public override void handleAfterUndelete() {

    }
}