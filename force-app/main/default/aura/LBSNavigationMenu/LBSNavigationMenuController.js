({
   onClick : function(component, event, helper) {
       var id = event.target.dataset.menuItemId;
       console.log('id==>' + id);
       alert('hello' +component.get('v.navBar'));
       if (id) {
           component.getSuper().navigate(id);
           console.log('id CHeck==>' + component.getSuper().navigate(id));
        }
       
  }
})