({
    doInit : function(component, event, helper) {
        component.set("v.screenWidth",screen.width);
        var action = component.get("c.getcontacts");
        action.setCallback(this, function (response) {
            console.log("State : "+response.getState());
            if (response.getState() === "ERROR") {
                console.log(response.getError());
                component.find("leh").passErrors(response.getError());
            } else if (response.getState() === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log("resp : "+resp);
                component.set("v.contacts",resp);
            }
        });
        $A.enqueueAction(action);
    }
})