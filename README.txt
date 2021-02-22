1. Modelling (Configuration)

1. Individual customers are stored as Account records in Salesforce with 'Customer Account' record type
2. Financial Accounts are stored in Financial_Account__c custom object which has a master detail relationship with Account
3. Trasactions are stored in Transaction_History__c custom object which has a master detail relationship with Financial Accounts
4. Calculated Balance on Financial Account is rolled up and depending on type of transaction (debit or credit) the balance is calculated by adding or subtracting the transaction amount.


2. Provisioning

1. The unique ABID is generated in apex using random logic, There might be very very less probability that ABID may coincide in that case we may need to add additional logic/automation to
   handle duplicate. For eg post processing logic using duplicate rules and rectifying using batch if duplicates found.
   We can also generate sequential nos depending upon created date to avoid the random probability
2. In the event of dataloss we can upload the same field/Column value from the external backed up system like Ownbackup, we can also turn off the trigger and do upload or copy the ABID field to another field for reference

3. Receiving Transactions

1. Idempotent design is handled using matching and duplicate rule on Transaction History object using datetime and accountNo field such that for a particular accountNo at a given time there can 
   happen only one transaction
2. Below is the sample transaction list used.
<!------------------------------
{"Transactions": [
	{
		"abid":"ACME 123 456 789",
		"accountNumber": 123456789,
		"amount": 125.68,
		"currency": "AUD",
		"date": "2020/01/01",
		"merchantABN": 123456789,
		"merchantBSB": 123456,
		"merchantName": "Beau Flowers",
		"time": "17:32:25",
		"type": "debit"
	},
	{
		"abid":"ACME 789 456 123",
		"accountNumber": 123452789,
		"amount": 250.00,
		"currency": "AUD",
		"date": "2020/01/02",
		"merchantABN": 987456123,
		"merchantBSB": 987654,
		"merchantName": "ABC Motors",
		"time": "14:30:20",
		"type": "debit"
	}
]}
----------------------------------------!>
 
Permission Set - Branch_Member
Connected App - Transactions_Connected_App
Lightning App - ACME Bank App


