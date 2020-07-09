({
    createQuoteRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": component.get("v.quoteObjectName")
        });
        createRecordEvent.fire();
    },
    
    createAccountRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": component.get("v.accountObjectName")
        });
        createRecordEvent.fire();
    },
    
    createOpportunityRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": component.get("v.opportunityObjectName")
        });
        createRecordEvent.fire();
    },
    
    
    createLeadRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": component.get("v.leadObjectName")
        });
        createRecordEvent.fire();
    }
    
})