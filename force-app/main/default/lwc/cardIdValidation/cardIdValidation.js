import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchHolidays from '@salesforce/apex/CardIdValidationController.searchHolidays';
const columns = [
    { label: 'Date of Birth', fieldName: 'birthDate' },
    { label: 'Gender', fieldName: 'gender' },
    { label: 'SA citizen', fieldName: 'saCitizen' },
    { label: 'Holiday Name', fieldName: 'holidateName' },
    { label: 'Holiday Description', fieldName: 'holidateDescription' },
    { label: 'Holiday Type', fieldName: 'holidateType' }

];

const LABELS = {
    title : 'Error',
    variant : 'error'
};
export default class CardIdValidation extends LightningElement {
    buttonDisabled=true;
    idNumber;
    dateOfBirth;
    gender;
    isSAcitizen;
    data=[];
    columns=columns;
    labels = LABELS;
    empty = true;
    handleClick() {
        this.data=[];
        this.buttonDisabled = true;
        let idNumber = this.template.querySelector('[data-id="idNumber"]').value;
        this.gender = this.getGender(idNumber);
        this.isSAcitizen = this.getCitizenship(idNumber);

        let identNumbObj = { 'sobjectType': 'SA_Identification__c' };
        identNumbObj.Identification_Number__c = this.idNumber;
        identNumbObj.Gender__c = this.gender;
        identNumbObj.SA_Citizen__c = this.isSAcitizen;
        identNumbObj.Date_of_Birth__c = this.dateOfBirth;

        searchHolidays({objSAId:identNumbObj})
            .then(result=>{
                
                this.buttonDisabled=false;
                this.empty=false;
                this.data= [{
                                birthDate:result.birthDate,
                                gender : result.gender,
                                saCitizen : result.saCitizen?'Yes':'No',
                                holidateName : result.holidateName,
                                holidateDescription : result.holidateDescription,
                                holidateType : result.holidateType
                            }];
                console.log(result);
            })
            .catch(error=>{
                console.log(error);
            });
    }
    handleChange(event) {
        let numberIdLength =  event.target.value.length;
        if(numberIdLength==13) {
            this.buttonDisabled = !this.validIdNumber(event.target.value);
            if(this.buttonDisabled) {
                this.showMessage(
                    this.labels.title,
                    this.labels.variant,
                    'This is an invalid Number Id'
                );
            }else {
                this.idNumber = event.target.value;
            }
        }else if(numberIdLength>13) {
            this.showMessage(
                this.labels.title,
                this.labels.variant,
                'You must input a 13 digit number'
            );
            this.buttonDisabled = true;
        }
    }
    validIdNumber(value) {
          let isValidDate = this.validateDate(value);

          if(!isValidDate) return false;
          
          let nCheck = 0, bEven = false;
      
          for (var n = value.length - 1; n >= 0; n--) {
              var cDigit = value.charAt(n),
                    nDigit = parseInt(cDigit, 10);
      
              if (bEven && (nDigit *= 2) > 9) nDigit -= 9;
      
              nCheck += nDigit;
              bEven = !bEven;
          }
          
          return (nCheck % 10) == 0;
    }
    
    validateDate(value) {
        let year = value.substring(0,2);
        let month = value.substring(2,4);
        let day = value.substring(4,6);
        let d = new Date(month+'/'+day+'/'+year);
        console.log('isvalid date-->>'+d); 
        let isValidDate = d!=='Invalid Date';
        this.dateOfBirth = month+'/'+day+'/'+d.getFullYear();
        return isValidDate; 
    }
    
    getGender(value) {
        let gendNum = value.substring(6,10);
        let gender = (parseInt(gendNum)> 0 && parseInt(gendNum)< 5000)
                        ?'Female'
                        :(parseInt(gendNum)>= 5000 && parseInt(gendNum)<= 9999)
                            ?'Male'
                            :'Female';
        return gender;
    }

    getCitizenship(value) {
        let gendNum = value.substring(10,11);
        return gendNum===0;
    }

    showMessage(title,variant,message) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}