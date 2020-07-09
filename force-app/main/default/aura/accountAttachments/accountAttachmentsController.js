({
	openMatter:function(component, event, helper){
        //Get the event using registerEvent name. 
        var cmpEvent = component.getEvent("imanageRefreshEvent"); 
        component.set("v.sObjectName", 'case');
        console.log('object name : '+component.get("v.sObjectName"));
        //Set event attribute value
        cmpEvent.setParams(
            {"ObjectName" : "case"}
        ); 
        cmpEvent.fire(); 
    }
    
})