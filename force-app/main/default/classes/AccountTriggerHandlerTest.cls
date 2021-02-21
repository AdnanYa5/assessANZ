/**
 * @author         : Adnan
 * @date           : 22/02/2021
 * 
 * @group          : Account
 * @group-content  : ../../ApexDocContent/AccountTriggerHandlerTest.htm
 *  
 * @description    : Test class for AccountTriggerHandler.
 * 
 * @history        : v1.0  22/02/2021 Adnan Initial Version
 * 
 */
@isTest
public inherited sharing class AccountTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        createCustomerAccounts(100);
    }
    
    @isTest
    static void testCustomerAccounts(){
        Test.startTest();
        createCustomerAccounts(50);
        Test.stopTest();
        List<Account> accountListToTest = [Select Id, Name, ABID__c from Account];
        
        //***************--------ASSERTS----------*****************
        System.assertEquals(150, accountListToTest.size() , 'All accounts not created, check debug logs');
        List<String> abidList = new List<String>();
        for(Account acc : accountListToTest){
            abidList.add(acc.ABID__c);
        }
        System.assertEquals(150, ABIDList.size() , 'All ABIDs are not created');
        System.assert(accountListToTest[0].ABID__c != null, 'ABID is null, check the ABID creation logic through debug logs');
    }

    //We can add this in TestFactory also
    /*********************************************************
    * @name         createCustomerAccounts
    * @description  Generaic method for creating accounts in bulk
    * @param        Integer noOfAccount
    * @return       List<Account>
    **********************************************************/
    static List<Account> createCustomerAccounts(Integer noOfAccounts){
        List<Account> customerAccounts = new List<Account>();
        for(Integer i=0; i<noOfAccounts;i++){
            Account acc = new Account();
            acc.Name = 'Test Account '+i;
            acc.recordTypeId = AccountTriggerHandler.CUSTOMER_ACCOUNT_RECORD_TYPE_ID;
            customerAccounts.add(acc);
        }
        insert customerAccounts;
        return customerAccounts;
    }
}