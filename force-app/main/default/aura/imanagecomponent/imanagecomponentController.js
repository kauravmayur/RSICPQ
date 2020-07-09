({
    
    doInit: function(component, event, helper) {
        var action = component.get("c.getData");
		       console.log('Inside Init'); 
        action.setParams({
            matterId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('response : '+response.getReturnValue())
            if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            else{
                component.set("v.MatterName", response.getReturnValue().val);
                component.set("v.sObjectName", response.getReturnValue().objName);
                console.log('Matter : '+component.get("v.MatterName"));
                console.log('sObjectName : '+component.get("v.sObjectName"));
            }
        });
        $A.enqueueAction(action);
    },
    refreshChildComp : function(component, event, helper) {
        console.log('***refreshChildComp***');
        var ObjectName = event.getParam("ObjectName");
        component.set("v.sObjectName", ObjectName);
        component.set("v.MatterName", 'Matter - 00001025');
    }
})