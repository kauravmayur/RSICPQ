public without sharing class LBSSUPPORTFINAL_class {
	@AuraEnabled
    public static Contact getContactInfo(){
		
		User u = [Select contactId from User where id=:UserInfo.getUserId()];
			List<Contact> con = [Select Id from Contact where id=:u.contactId];
			if(!con.isEmpty()){
				return con[0];
			}else{
				return null;
			}
	}
}