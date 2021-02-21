/**
 * @author         : Adnan
 * @date           : 22/02/2021
 * 
 * @group          : GenerateUniqueID
 * @group-content  : ../../ApexDocContent/GenerateUniqueID.htm
 *  
 * @description    : Generic class for creating ids of different types
 * 
 * @testClass      : AccountTriggerHandlerTest
 * 
 * @history        : v1.0  22/02/2021 Adnan Initial Version - Developed as part ANZ assessment
 * 
 */
public inherited sharing class GenerateUniqueID {
    
    /*********************************************************
    * @name         getUniqueId
    * @description  Method to generate uniqueid depending upon 
    *               type
    * @param        String type
    * @return       string
    **********************************************************/
    public static string getUniqueId(String type){
        if(type == GenerateUniqueIDConstants.ABID){
            return generateABID();
        } else{
            return null;
        }
    }

    /*********************************************************
    * @name         generateABID
    * @description  This method contains the logic for ABID 
    * @param        
    * @return       string
    **********************************************************/
    private static string generateABID(){
        Integer randomABIDNumber = Integer.valueOf((Math.random() * Math.pow(10, GenerateUniqueIDConstants.MAX_NUM_CHAR_ABID)));
        String randomABIDString  = '';
        for(Integer i=0; i<GenerateUniqueIDConstants.MAX_ALPHA_CHAR_ABID; i++){
            randomABIDString += GenerateUniqueIDConstants.CAPITAL_CHARS[Integer.valueof((Math.random() * (GenerateUniqueIDConstants.CAPITAL_CHARS.size() - 1)))];
        }
        return (randomABIDString+randomABIDNumber).trim();
    }
}