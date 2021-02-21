/**
 * @author         : Adnan
 * @date           : 22/02/2021
 * 
 * @group          : TransactionRestResource
 * @group-content  : ../../ApexDocContent/TransactionRestResourceTest.htm
 *  
 * @description    : Test class for TransactionRestResource.
 * 
 * @history        : v1.0  22/02/2021 Adnan Initial Version - Developed as part ANZ assessment
 * 
 */
@isTest
public inherited sharing class TransactionRestResourceTest {
    @TestSetup
    static void makeData(){
        Account custAccount = createCustomerAccount();
        createFinancialAccount(custAccount.Id);
    }
    
    static Account createCustomerAccount(){
        Account acc = new Account();
        acc.Name = 'Test Accountxyz';
        acc.recordTypeId = AccountTriggerHandler.CUSTOMER_ACCOUNT_RECORD_TYPE_ID;
        insert acc;
        return acc;
    }

    static Financial_Account__c createFinancialAccount(Id custAccId){
        Financial_Account__c facc = new Financial_Account__c();
        facc.Name = 'Mr Test Spending Account';
        facc.recordTypeId = Schema.SObjectType.Financial_Account__c.getRecordTypeInfosByName().get(TransactionHistoryTriggerHandler.SPENDING).getRecordTypeId();
        facc.Account_Number__c = 123456789;
        facc.Customer_Account__c = custAccId;
        insert facc;
        return facc;
    }
    
    @isTest static void testTransactionsCreation(){
        String requestBody = '{"Transactions": [{"abid":"ACME 123 456 789","accountNumber": 123456789,"amount": 125.68,"currency": "AUD","date": "2020/01/01","merchantABN": 123456789,"merchantBSB": 123456,"merchantName": "Beau Flowers","time": "17:32:25","type": "debit"},{"abid":"ACME 789 456 123","accountNumber": 123452789,"amount": 250.00,"currency": "AUD","date": "2020/01/02","merchantABN": 987456123,"merchantBSB": 987654,"merchantName": "ABC Motors","time": "14:30:20","type": "debit"}]}';

        RestRequest request = new RestRequest();
        request.requestUri = Label.Current_Instance + '/services/apexrest/Transactions/v1/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(requestBody);
        RestContext.request = request;
        Test.startTest();
        List<String> response = TransactionRestResource.doPost();
        Test.stopTest();

        //***************--------ASSERTS----------*****************
        System.assert(response != null, 'Response not recieved, please check debug logs');
        List<Transaction_History__c> transHistList = [Select id, Name from Transaction_History__c];
        System.assertEquals(1, transHistList.size(), 'Transactions are not created, check debug logs');
    }
}