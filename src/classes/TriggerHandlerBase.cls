/**
 * Base class for all triggers handlers.
 * How to use it:
 * 1) Create a domain class for your SObject (Case for example) that extends TriggerHandlerBase.
 * 2) Override the handler methods that you need.
 * 3) On the trigger, call TriggerHandlerBase.triggerHandler passing a instance of your handler (like CaseCommentHandler).
 *    Example: TriggerHandlerBase.triggerHandler(new CaseCommentHandler());
 */

public virtual class TriggerHandlerBase {
    public static Boolean blockTrigger = false;

    protected List<SObject> newRecordsList;
    protected Map<Id, SObject> oldRecordsMap;
    protected Map<Id, SObject> newRecordsMap;

    public TriggerHandlerBase() {
        System.debug('In TriggerHandlerBase constructor');
        
        oldRecordsMap = Trigger.oldMap;
        newRecordsMap = Trigger.newMap;
        newRecordsList = Trigger.new;
    }

    public static void triggerHandler(TriggerHandlerBase triggerHandler) {
        
        System.debug('In triggerHandler method of TriggerHandlerBase');
        
        if (TriggerHandlerBase.blockTriggerExecution()) {
            return;
        }

        if (Trigger.isBefore) {
            if (Trigger.isInsert) triggerHandler.handleBeforeInsert(); 
            else if (Trigger.isUpdate) triggerHandler.handleBeforeUpdate(); 
            else if (Trigger.isDelete) triggerHandler.handleBeforeDelete();
        } else {
            if (Trigger.isInsert) triggerHandler.handleAfterInsert(); 
            else if (Trigger.isUpdate) triggerHandler.handleAfterUpdate(); 
            else if (Trigger.isDelete) triggerHandler.handleAfterDelete(); 
            else if (Trigger.isUndelete) triggerHandler.handleAfterUndelete();
        }
    }

    public virtual void handleBeforeInsert() {
    }

    public virtual void handleBeforeUpdate() {
    }

    public virtual void handleAfterInsert() {
    }

    public virtual void handleAfterUpdate() {
    }

    public virtual void handleBeforeDelete() {
    }

    public virtual void handleAfterDelete() {
    }

    public virtual void handleAfterUndelete() {
    }

    public static Boolean blockTriggerExecution() {
        return blockTrigger;
    }
}