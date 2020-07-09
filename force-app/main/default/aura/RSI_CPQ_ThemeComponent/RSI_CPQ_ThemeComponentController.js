({
    doInit : function(component, event, helper) {
        var url = $A.get('$Resource.LBSCustomOwnIcon');
        component.set('v.backgroundImageURL', url);
        
        var staticLabel = $A.get("$Label.c.RSI_CPQ_BrandLogo");
        console.log(staticLabel);
		component.set("v.mylabel", staticLabel);
        
    }
    
})