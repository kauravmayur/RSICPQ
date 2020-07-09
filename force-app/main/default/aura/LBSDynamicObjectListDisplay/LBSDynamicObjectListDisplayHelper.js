({
    loadData: function (cmp, evt, help) {
        // Declare all varaiables.
        let methodName = 'c.fetchObject',
            params = {
                'strSObjectName': cmp.get('v.object'),
                'strFieldsetName': cmp.get('v.fieldsToDisplay'),
                'sortByFieldName': cmp.get('v.sortByFieldName'),
                'ascDesc': cmp.get('v.ascDesc')
            },
            // This is callback function for handling Response
            callback = (response) => {
                if (response) {
                
                cmp.set('v.objectLabel', response.objectLabel);
                cmp.set('v.error', response.error);
                cmp.set('v.errorFlag', response.errorFlag);
                this.createHeader(cmp, response['lstFields'])
                this.createRows(cmp, response['lstFields'], response['lstSObject'])
            }
        }
    //Call the apex method 
    this.callApex(cmp, methodName, params, callback);
},
 
 createHeader: function (cmp, field) {
    
    let orderData = field.map(e => {
        var obj = {};
                              obj['label'] = e['label']
                              obj['fieldPath'] = e['fieldPath']
                              obj['isSortUp'] = true
                              obj['isSortDown'] = false
                              obj['byDefaultSort'] = e['label'] == 'Name' ? true : false
                              return obj;
                              })
    cmp.set('v.colData', orderData);
    console.log(orderData);
    
},
    
    createRows: function (cmp, field, row) {
        let filedPath = field.map(e => {
            return e['fieldPath']
        })
        cmp.set('v.fieldPath', filedPath);
        cmp.set('v.allRowData', row);
        cmp.set('v.rowData', row.splice(0, cmp.get('v.prev')));
        var accHeader = 'Top '+cmp.get('v.prev')+' '+cmp.get('v.objectLabel');
        console.log('accHeader : '+accHeader);
        cmp.set('v.AccountTopHeader', accHeader);
        console.log('accHeader 1 : '+cmp.get('v.AccountTopHeader'));
    },
        
        toast: function (title, message, type) {
            let toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: title,
                message: message,
                type: type,
            });
            toastEvent.fire();
        },
            //This method for call the apex method.
            callApex: function (cmp, methodName, params, callback) {
                let state, action;
                action = cmp.get(methodName);
                action.setParams(params);
                action.setCallback(this, function (response) {
                    state = response.getState();
                    if (state === "SUCCESS") {
                        callback(response.getReturnValue())
                    }
                });
                $A.enqueueAction(action);
            }
})