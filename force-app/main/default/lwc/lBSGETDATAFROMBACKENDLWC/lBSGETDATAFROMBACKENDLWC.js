import { LightningElement, wire, track, api } from 'lwc';
import getAccounts from '@salesforce/apex/GetDataFromBackEndController.getAccounts';
import getOportunities from '@salesforce/apex/GetDataFromBackEndController.getOpportunity';

const table_coulms = [
{label : 'Account Name', fieldName : 'Name', type : 'text'},
//{label : 'Description', fieldName : 'Description', type : 'text'},
{label : 'Amount', fieldName : 'AnnualRevenue', type : 'number'}
];

const table_coulmsOpp = [
{label : 'Account Name', fieldName : 'accountName', type : 'text'},
{label : 'Opportunity Name', fieldName : 'Name', type : 'text'},
//{label : 'Description', fieldName : 'Description', type : 'text'},
{label : 'Amount', fieldName : 'Amount', type : 'number'}

];

export default class LBSGETDATAFROMBACKENDLWC extends LightningElement {
columns=table_coulms;
columnsOpp=table_coulmsOpp;

@track page = 1; //current page
totalPages = 5; //total page

@track error;

@api recordId; //current caseId
@api wiredCase;
@api realCase;
@track accountName;

@wire(getAccounts) accounts;
@wire(getOportunities) opportunity;

@wire(getOportunities)  
    getOppDetails({ data, error }) {
        if(data){
            this.realCase = { ...data };
            this.accountName = this.realCase.Account.Name; 
    }
        else if (error) {
            // handle error
            console.error('ERROR => ', error);
    }
}


}