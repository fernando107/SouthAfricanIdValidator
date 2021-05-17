public class CalendarificCallOut {

    public static CalendarificResponseParser searchHolidays(Date birthDate, String country) {
        Integer year = Date.Today().year();
        Integer month = birthDate.month();
        Integer day = birthDate.day();
        Http http = new Http();
        HttpRequest request = new HttpRequest(); 
        request.setEndpoint('callout:calendarApi/api/v2/holidays?api_key=05ffaa9e3f94996a12e62719fe9a93b8a8719f97&country='+country+'&year='+year+'&month='+month+'&day='+day);
        request.setMethod('GET');
        HttpResponse response = http.send(request); 
        system.debug('response1-->'+response.getBody());
        String holidayResponse = response.getBody().replace('"datetime"', '"datetime_z"');
        holidayResponse = holidayResponse.replace('"date"', '"date_z"');
        CalendarificResponseParser holidayInfo = CalendarificResponseParser.parse(holidayResponse); 
        
        return holidayInfo;
    }

}
