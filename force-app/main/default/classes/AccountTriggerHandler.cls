/**
 * @author         : Adnan
 * @date           : 22/02/2021
 * 
 * @group          : Account
 * @group-content  : ../../ApexDocContent/AccountTriggerHandler.htm
 *  
 * @description    : TriggerHandler class for account trigger
 * 
 * @testClass      : AccountTriggerHandlerTest
 * 
 * @history        : v1.0  22/02/2021 Adnan Initial Version - Developed as part ANZ assessment
 * 
 */
public inherited sharing class AccountTriggerHandler {
    public static final String CUSTOMER_ACCOUNT = 'Customer Account';
    public static final Id CUSTOMER_ACCOUNT_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(AccountTriggerHandler.CUSTOMER_ACCOUNT).getRecordTypeId();

    /*********************************************************
    * @name         beforeInsertHandler
    * @description  Generaic method for before insert logic
    * @param        List<Account> newAccounts
    * @return       void
    **********************************************************/
    public static void beforeInsertHandler(List<Account> newAccounts){
        for(Account acc: newAccounts){
            //In the event of data loss upload the ABID field column from the external backed up system 
            //So that the ABID is not newly created.
            if(acc.recordTypeId == CUSTOMER_ACCOUNT_RECORD_TYPE_ID && acc.ABID__c == null){
                acc.ABID__c = GenerateUniqueID.getUniqueId(GenerateUniqueIDConstants.ABID);
            }         
        }
        publishCustomerEvent(newAccounts);
    }

    /*********************************************************
    * @name         publishCustomerEvent
    * @description  This method contains the logic for publishing
    *               platform event, we can also make it generic by
    *               moving the logic into a common service class
    * @param        List<Account> newAccounts
    * @return       void
    **********************************************************/
    static void publishCustomerEvent(List<Account> newAccounts){
       List<ACME_Bank_Customers__e> custEventList = new List<ACME_Bank_Customers__e>();
       
       for(Account acc: newAccounts){
           ACME_Bank_Customers__e custEvent = new ACME_Bank_Customers__e();
           custEvent.Name__c = acc.Name;
           custEvent.Address__c = acc.BillingAddress != null ? String.valueOf(acc.BillingAddress) : '';
           custEvent.Phone__c = acc.Phone != null ? String.valueOf(acc.Phone) : '';
           custEvent.ABID__c = acc.ABID__c;
           custEventList.add(custEvent);
       }

        List<Database.SaveResult> results = EventBus.publish(custEventList);
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('Successfully published customer event.');
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error returned: ' +
                                err.getStatusCode() +
                                ' - ' +
                                err.getMessage());
                }
            }
        }
    }
}