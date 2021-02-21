/**
 * @author         : Adnan
 * @date           : 22/02/2021
 * 
 * @group          : TransactionRestResource
 * @group-content  : ../../ApexDocContent/TransactionRestResource.htm
 *  
 * @description    : Apex Rest webservice class for transactions loaded from
 *                   external systems 
 * 
 * @testClass      : TransactionRestResourceTest
 * 
 * @history        : v1.0  22/02/2021 Adnan Initial Version - Developed as part ANZ assessment
 * 
 */
@RestResource(urlMapping='/Transactions/v1/*')
global with sharing class TransactionRestResource {

    /*********************************************************
    * @name         doPost
    * @description  POST method for adding new transactions
    * @param        
    * @return       List<String>
    **********************************************************/
    @HttpPost
    global static List<String> doPost (){
        List<String> responseList = new List<String>();
        RestRequest request = RestContext.request;
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        List<Map<String, Object>> data = new List<Map<String, Object>>();
        for (Object instance : (List<Object>)params.get('Transactions')){
            data.add((Map<String, Object>)instance);   
        }
        List<Transaction_History__c> transList = new List<Transaction_History__c>();
        for(Object objTrans : data){
            Map<String, Object> singleTransactionMap = (Map<String, Object>)objTrans;
            Transaction_History__c trans = new Transaction_History__c();
            for(String fieldName : singleTransactionMap.keySet()){
                if (fieldName == 'abid')
                    trans.ABID__c = (String)singleTransactionMap.get(fieldName);
                if (fieldName == 'accountNumber')
                    trans.Account_Number__c = (Integer)singleTransactionMap.get(fieldName);
                if (fieldName == 'amount')
                    trans.Amount__c = (Decimal)singleTransactionMap.get(fieldName);
                if (fieldName == 'currency') 
                    trans.Currency__c = (String)singleTransactionMap.get(fieldName);
                if (fieldName == 'date'){
                	String transDateString = (String)singleTransactionMap.get(fieldName);
                    trans.Transaction_Date__c = Date.valueOf(transDateString.replace('/', '-'));
            	}               
                if (fieldName == 'merchantABN'){
                    trans.Merchant_ABN__c = (Decimal)singleTransactionMap.get(fieldName);
                }     
                if (fieldName == 'merchantBSB'){
                    trans.Merchant_BSB__c = (Decimal)singleTransactionMap.get(fieldName);
                }    
                if (fieldName == 'merchantName')
                    trans.Merchant_Name__c = (String)singleTransactionMap.get(fieldName);
                if (fieldName == 'time')
                    trans.Transaction_Time__c = (String)singleTransactionMap.get(fieldName);
                if (fieldName == 'type')
                    trans.Type__c = (String)singleTransactionMap.get(fieldName);              
            }
            transList.add(trans);
        }

       if (transList != null) {
            Database.SaveResult[] srList = Database.insert(transList, false);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    responseList.add('Successfully inserted transaction. transaction ID:'+sr.getId());
                } else {
                    for(Database.Error err : sr.getErrors()) {
                        responseList.add('error occured ---'+err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }
       }
             
        return responseList;
    }
}