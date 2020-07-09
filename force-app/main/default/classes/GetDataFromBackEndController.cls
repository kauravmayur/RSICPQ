public with sharing class GetDataFromBackEndController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        return [select Id, Name, Description, AnnualRevenue, (select id, amount from Opportunities ) from Account where AnnualRevenue!=null ORDER BY AnnualRevenue desc LIMIT 10];

    }
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunity(){
        return [select Id, Name, Description, account.name, account.AnnualRevenue, Amount from Opportunity where Amount!=null ORDER BY amount desc LIMIT 10];
        
    }
    
    public static List<SBQQ__Quote__c> getQuote(){
        return [select CreatedById,CreatedDate,CurrencyIsoCode,Id,IsDeleted,LastActivityDate,LastModifiedById,
                LastModifiedDate,LastReferencedDate,LastViewedDate,Name,OwnerId,SBQQ__Account__c,SBQQ__AdditionalDiscountAmount__c,
                SBQQ__AverageCustomerDiscount__c,SBQQ__AveragePartnerDiscount__c,SBQQ__BillingCity__c,SBQQ__BillingCountry__c,
                SBQQ__BillingFrequency__c,SBQQ__BillingName__c,SBQQ__BillingPostalCode__c,SBQQ__BillingState__c,SBQQ__BillingStreet__c,
                SBQQ__ConsumptionRateOverride__c,SBQQ__ContractingMethod__c,SBQQ__CustomerAmount__c,SBQQ__CustomerDiscount__c,
                SBQQ__DaysQuoteOpen__c,SBQQ__DefaultTemplate__c,SBQQ__DeliveryMethod__c,SBQQ__DistributorDiscount__c,SBQQ__Distributor__c,
                SBQQ__DocumentStatus__c,SBQQ__EmailTemplateId__c,SBQQ__EndDate__c,SBQQ__ExpirationDate__c,SBQQ__FirstSegmentTermEndDate__c,
                SBQQ__GenerateContractedPrice__c,SBQQ__Introduction__c,SBQQ__Key__c,SBQQ__LastCalculatedOn__c,SBQQ__LastSavedOn__c,
                SBQQ__LineItemCount__c,SBQQ__LineItemsGrouped__c,SBQQ__LineItemsPrinted__c,SBQQ__ListAmount__c,SBQQ__MarkupRate__c,
                SBQQ__MasterContract__c,SBQQ__MasterEvergreenContract__c,SBQQ__NetAmount__c,SBQQ__Notes__c,SBQQ__Opportunity2__c,
                SBQQ__OrderByQuoteLineGroup__c,SBQQ__OrderBy__c,SBQQ__Ordered__c,SBQQ__OrderGroupID__c,SBQQ__OriginalQuote__c,SBQQ__PaperSize__c,
                SBQQ__PartnerDiscount__c,SBQQ__Partner__c,SBQQ__PaymentTerms__c,SBQQ__PricebookId__c,SBQQ__PriceBook__c,SBQQ__PrimaryContact__c,
                SBQQ__Primary__c,SBQQ__QuoteLanguage__c,SBQQ__QuoteProcessId__c,SBQQ__QuoteTemplateId__c,SBQQ__RegularAmount__c,SBQQ__RenewalTerm__c,
                SBQQ__RenewalUpliftRate__c,SBQQ__SalesRep__c,SBQQ__ShippingCity__c,SBQQ__ShippingCountry__c,SBQQ__ShippingName__c,
                SBQQ__ShippingPostalCode__c,SBQQ__ShippingState__c,SBQQ__ShippingStreet__c,SBQQ__Source__c,SBQQ__StartDate__c,SBQQ__Status__c,
                SBQQ__SubscriptionTerm__c,SBQQ__TargetCustomerAmount__c,SBQQ__TotalCustomerDiscountAmount__c,SBQQ__Type__c,SBQQ__Uncalculated__c,
                SBQQ__Unopened__c,SBQQ__WatermarkShown__c,SystemModstamp from SBQQ__Quote__c ORDER BY Name];
    }
    
    public static List<SBQQ__QuoteDocument__c> getQuoteDocument(){
        return [select ASSFCPQ__Agreement__c,CreatedById,CreatedDate,CurrencyIsoCode,Document_Link__c,Id,IsDeleted,LastActivityDate,
                LastModifiedById,LastModifiedDate,Name,SBQQ__AttachmentId__c,SBQQ__CustomerAmount__c,SBQQ__DocumentId__c,
                SBQQ__ElectronicSignature__c,SBQQ__Key__c,SBQQ__ListAmount__c,SBQQ__NetAmount__c,SBQQ__Opportunity__c,SBQQ__OutputFormat__c,
                SBQQ__PaperSize__c,SBQQ__PrimaryContactId__c,SBQQ__QuoteTemplate__c,SBQQ__Quote__c,SBQQ__SignatureStatus__c,SBQQ__Template__c,
                SBQQ__Version__c,SBQQ__ViewRecordId__c,SystemModstamp  from SBQQ__QuoteDocument__c ORDER BY Name];
    }
    
}