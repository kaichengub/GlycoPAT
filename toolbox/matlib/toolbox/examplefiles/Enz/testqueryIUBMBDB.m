function test_suite = testqueryIUBMBDB 
initTestSuite;

function testqueryIUBMBDBOutputCheck1
    exptValue = 'acetyl-CoA:glycine C-acetyltransferase'; 
    queryResult = queryIUBMBDB([2;3;1;29]); 
    restValue = queryResult.systname;
    assertEqual(exptValue,restValue);
    
 function testqueryIUBMBDBOutputCheck2
    exptValue = ' acetyl-CoA:glycine C-acetyltransferase'; 
    queryResult = queryIUBMBDB([2;4;1;29]); 
    restValue = queryResult.systname;
    assertEqual(exptValue,restValue);
    
    
function testqueryIUBMBDB2ErrorHandle 
    f =  @() queryIUBMBDB([2;3;100;29]); 
   assertExceptionThrown(f,'MATLAB:GEAT:webAccess'); 
    

