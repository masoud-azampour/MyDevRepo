/**
 * Case helper class to be called in the Case handler class
 * 
 */

public with sharing class CaseHelper {
    
    // example helper method needed for some logging logic
    public static void doLogCaseChanges(Map<Id, Case> oldCaseMap, List<Case> newCaseList) {
    
        System.debug('Executing doLogCaseChanges -->  oldCaseMap = ' + oldCaseMap + ' | newCaseList = ' + newCaseList);
    
        //TODO: your logic here to log case changes into an integration log custom object
    }
    
    public static void foo(Map<Id, Case> oldCaseMap, List<Case> newCaseList) {
        //Some other logic 
    }
}