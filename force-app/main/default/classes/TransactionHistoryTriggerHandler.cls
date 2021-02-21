/**
 * @author         : Adnan
 * @date           : 22/02/2021
 * 
 * @group          : TransactionHistoryTriggerHandler
 * @group-content  : ../../ApexDocContent/TransactionHistoryTriggerHandler.htm
 *  
 * @description    : TriggerHandler class for transaction history trigger
 * 
 * @testClass      : TransactionRestResourceTest
 * 
 * @history        : v1.0  22/02/2021 Adnan Initial Version - Developed as part ANZ assessment
 * 
 */
public inherited sharing class TransactionHistoryTriggerHandler {
    public static final String SPENDING = 'Spending';

    /*********************************************************
    * @name         beforeInsertHandler
    * @description  Generaic method for before insert logic
    * @param        List<Transaction_History__c> newTransactions
    * @return       void
    **********************************************************/
    public static void beforeInsertHandler(List<Transaction_History__c> newTransactions){
        updateFinancialAccount(newTransactions);
    }

    /*********************************************************
    * @name         updateFinancialAccount
    * @description  This method contains the logic for updating
                    transactions with their financial accounts
    * @param        List<Transaction_History__c> newTransactions
    * @return       void
    **********************************************************/
    static void updateFinancialAccount(List<Transaction_History__c> newTransactions){
        List<Decimal> accountNosList = new List<Decimal>();
        for(Transaction_History__c trans : newTransactions){
            accountNosList.add(trans.Account_Number__c);
        }

        List<Financial_Account__c> fAccountsList = [Select Id, Name, Account_Number__c from Financial_Account__c where Account_Number__c IN: accountNosList];
        Map<Decimal, Id> accNoWithAccIdMap = new Map<Decimal, Id>();
        if(fAccountsList != null){
            for(Financial_Account__c facc : fAccountsList){
                accNoWithAccIdMap.put(facc.Account_Number__c, facc.Id);
            }
        }

        //Logic for handling transactions with no account number present
        for(Transaction_History__c trans : newTransactions){
            trans.Financial_Account__c = accNoWithAccIdMap.get(trans.Account_Number__c);
            if (trans.Financial_Account__c == null) {
                trans.addError(Label.Financial_Accounts_Error);
            }
        }
    }
}
