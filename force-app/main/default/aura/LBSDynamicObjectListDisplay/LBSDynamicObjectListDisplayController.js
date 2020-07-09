({
    loadData: function(cmp, evt, help) {
        help.loadData(cmp, evt, help)
    },
    
    directToSobjectHome : function (cmp, evt, help) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": cmp.get('v.object')
        });
        homeEvent.fire();
    },
    
    refresh: function(cmp, evt, help) {
        $A.get('e.force:refreshView').fire();
    },
    
})