public with sharing class RSI_ChangeBrandLogo {
    @AuraEnabled
    public static String getBrandLogo(String devName) {
        Brand_Logo__mdt brand = [SELECT DeveloperName FROM Brand_Logo__mdt WHERE DeveloperName = :devName];
        String brandLogo = brand.DeveloperName;
        return brandLogo;
    }

}