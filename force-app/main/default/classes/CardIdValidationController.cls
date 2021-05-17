public without sharing class CardIdValidationController {
    @AuraEnabled
    public static searchResponse searchHolidays(SA_Identification__c objSAId){
        try {
            searchResponse searchResults;
            Decimal numOfSearches = 0;
            List<SA_Identification__c> idSA = [
                SELECT  
                Number_of_Searches__c
                FROM SA_Identification__c 
                WHERE Identification_Number__c =:objSAId.Identification_Number__c
            ];
            if(!idSA.isEmpty()){
                numOfSearches = idSA.get(0).Number_of_Searches__c; 
            } 
            numOfSearches ++;
            objSAId.Number_of_Searches__c=numOfSearches;
            CalendarificResponseParser res = CalendarificCallOut.searchHolidays(objSAId.Date_of_Birth__c, 'ZA');
  
                searchResults = handleResponse(res,objSAId.Identification_Number__c,objSAId);

            return searchResults; 
        } catch (Exception e) {
            System.debug(e.getMessage()); 
            searchResponse searchResults = new searchResponse();
            searchResults.errorMsg = e.getMessage();
            return searchResults;
        }
    }

    public static searchResponse handleResponse(CalendarificResponseParser objResponse, String idNumber, SA_Identification__c objSAId) {
        List<Holiday__c> lstHolidays = new List<Holiday__c>();
        if(objResponse.meta.code==200){
            for(CalendarificResponseParser.cls_holidays holiday : objResponse.response.holidays){
                String type = !holiday.type.isEmpty()?holiday.type.get(0):'';
                Date dateH = String.isNotBlank(holiday.date_z.iso)?Date.valueOf(holiday.date_z.iso):Date.Today();
                lstHolidays.add(
                    new Holiday__c(
                        Name = holiday.name,
                        Description__c = holiday.description,
                        Type__c = type,
                        Holiday_date__c = dateH,
                        SA_Id_Number__c = idNumber
                    )
                );
            }
        }
        
        
        upsert objSAId Identification_Number__c; 
        if(!lstHolidays.isEmpty())
            upsert lstHolidays SA_Id_Number__c; 

        searchResponse resp = new searchResponse();
        resp.birthDate = String.valueOf(objSAId.Date_of_Birth__c);
        resp.gender = objSAId.Gender__c;
        resp.saCitizen = objSAId.SA_Citizen__c; 
        resp.holidateName = !lstHolidays.isEmpty()?lstHolidays.get(0).Name:'There is not holidays on this birthday';
        resp.holidateDescription = !lstHolidays.isEmpty()?lstHolidays.get(0).Description__c:'N/A';
        resp.holidateType = !lstHolidays.isEmpty()?lstHolidays.get(0).Type__c:'N/A';
        resp.errorMsg = '';
        resp.hasResults = !lstHolidays.isEmpty();

        return resp;
    }

    public class searchResponse {
        @AuraEnabled public String birthDate; 
        @AuraEnabled public String gender;
        @AuraEnabled public Boolean saCitizen;
        @AuraEnabled public String holidateName;
        @AuraEnabled public String holidateDescription;
        @AuraEnabled public String holidateType; 
        @AuraEnabled public String errorMsg; 
        @AuraEnabled public Boolean hasResults; 
    }
}