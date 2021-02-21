/**
 * @author         : Adnan
 * @date           : 22/02/2021
 * 
 * @group          : GenerateUniqueID
 * @group-content  : ../../ApexDocContent/GenerateUniqueIDConstants.htm
 *  
 * @description    : Constants class for generating unique ids
 * 
 * @testClass      : AccountTriggerHandlerTest
 * 
 * @history        : v1.0  22/02/2021 Adnan Initial Version - Developed as part ANZ assessment
 * 
 */
public inherited sharing class GenerateUniqueIDConstants {
    public static final String  ABID = 'ABID';
    public static final Integer MAX_ALPHA_CHAR_ABID = 3;
    public static final Integer MAX_NUM_CHAR_ABID = 9;
    public static final List<String> CAPITAL_CHARS = new List<String>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
}
