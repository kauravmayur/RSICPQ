({
    doInit : function(component, event, helper) {
        var URLLink = component.get('v.backgroundImageURL');
        var url = $A.get('$Resource.'+URLLink);
        component.set('v.backgroundImageURL', url);
    }
})