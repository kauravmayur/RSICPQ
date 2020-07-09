({
    doInit : function(component, event, helper){
        var action = component.get("c.getContactInfo");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state  === "SUCCESS"){
                var retVal = response.getReturnValue();
                if(retVal != null && retVal != undefined){
                   console.log('retVal : '+retVal.ContactId);
                   console.log('retVal : '+retVal.Contact.AccountId);
                    component.set("v.user",retVal);
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    
    handleOnLoad : function(component, event, helper) {
        
    },
    getFieldValue : function(component, event, helper) {
        
       
        //alert(event.getParam('value'));
        var typeValue = event.getParam('value');
        if(typeValue == 'Other'){
            component.set("v.otherFlag", true);
        }
        else{
            component.set("v.otherFlag", false);
        }
    },
    handleOnSubmit : function(component, event, helper) {
        
    },
    
    handleOnSuccess : function(component, event, helper) {
        
        component.set("v.reloadForm", false);
        component.set("v.reloadForm", true);
        var recordId = event.getParams().response;
        console.log("recordId : "+recordId.id);
        var action = component.get("c.getRecordName");
        action.setParams({"recordId":recordId.id});
        action.setCallback(this, function (response) {
            console.log("State : "+response.getState());
            if (response.getState() === "ERROR") {
                console.log(response.getError());
            } else if (response.getState() === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log("resp : "+resp);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Support "'+resp+'" was created.',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    
    handleOnError : function(component, event, helper) {
        console.log("***handleOnError***");
    },
    
})