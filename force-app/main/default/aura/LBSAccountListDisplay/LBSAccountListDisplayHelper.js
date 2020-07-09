({
   //getAccounts: function(component, page, recordToDisply) {
     getAccounts: function(component) {    
 
      // create a server side action. 
      var toalNumberOfAccount = component.get("v.toalNumberOfAccount");
         var sortByAccountField = component.get("v.sortByAccountField");
         var sortAscDescAccount = component.get("v.sortAscDescAccount");
         var fieldsToDisplay = component.get("v.fieldsToDisplay");
         var dynamicHeaders = component.get("v.dynamicHeaders");
         
      var action = component.get("c.fetchAccount");
      // set the parameters to method 
      action.setParams({
         //"pageNumber": page,
         //"recordToDisply": recordToDisply,
          "toalNumberOfAccount" : toalNumberOfAccount,
          "sortByAccountField"  : sortByAccountField,
          "sortAscDescAccount"  : sortAscDescAccount,
          "fieldsToDisplay"		: fieldsToDisplay,
          "dynamicHeaders"		: dynamicHeaders
          
      });
      // set a call back   
      action.setCallback(this, function(a) {
         // store the response return value (wrapper class insatance)  
         var result = a.getReturnValue();
          debugger;
         console.log('result ---->' + JSON.stringify(result));
         // set the component attributes value with wrapper class properties.   
 
         //component.set("v.Accounts", result.accounts);
         //component.set("v.page", result.page);
         //component.set("v.total", result.total);
         //component.set("v.pages", Math.ceil(result.total / recordToDisply));
         component.set("v.Accounts", result);
 
      });
      // enqueue the action 
      $A.enqueueAction(action);
   }
})