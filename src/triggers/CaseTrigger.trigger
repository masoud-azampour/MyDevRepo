trigger CaseTrigger on Case(before insert ,before update, before delete, after insert, after update, after delete, after undelete) {
    
    System.debug('In Trigger CaseTrigger');
    
    // remember CaseHandler extends TriggerHandlerBase
    TriggerHandlerBase.triggerHandler(new CaseHandler());
}