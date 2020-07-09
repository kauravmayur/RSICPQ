({
    doInit : function(component, event, helper){
        var action = component.get("c.getContactInfo");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state  === "SUCCESS"){
                var retVal = response.getReturnValue();
                if(retVal != null && retVal != undefined){
                    component.set("v.Contactid",retVal);
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    handleOnLoad : function(component, event, helper) {
        
    },
    
    handleOnSubmit : function(component, event, helper) {
        
    },
    
    handleOnSuccess : function(component, event, helper) {
        component.set("v.reloadForm", false);
        component.set("v.reloadForm", true);
    },
    
    handleOnError : function(component, event, helper) {
        
    },
    
})