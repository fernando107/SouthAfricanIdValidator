# SouthAfricanIdValidator

The app name is South African Id Information and it was built using a LWC cardIdValidation (front-end) and an apex class controller(back-end), the object Holiday__c is used to store all the information regarding to each holiday that mathches the date of birth of each searched id number, SA_Identification__c is a object used to stored all the information regarding to the searched id number.

The connection between the API (https://calendarific.com/api) and salesforce was built using named credentials and 2 apex classes CalendarificCallOut which sends the request and CalendarificResponseParser which deserializes the response. 