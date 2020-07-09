({
    doInit: function (component) {
        component.set("v.screenWidth",screen.width);
        component.set('v.selectedItem', $A.get("$Label.c.Imanage_Overview"));
        var action = component.get("c.getfirstlastname");
        action.setCallback(this, function (response) {
            console.log("State : "+response.getState());
            if (response.getState() === "ERROR") {
                console.log(response.getError());
            } else if (response.getState() === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log("resp : "+resp);
                component.set("v.userInitials",resp);
            }
        });
        $A.enqueueAction(action);
    },
    
    handleBeforeSelect: function(component, event) {
        component.set('v.selectedItem', event.getParam('name'));
    },
    onProfileClick: function(component, event) {
        //alert('onProfileClick');
        //alert(event.getSource().get("v.label"));
        //alert(component.find("actionMenuItem").get("v.label"));
        component.set('v.selectedItem', event.getSource().get("v.label"));
    },
    openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   },
 
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
 
    
});