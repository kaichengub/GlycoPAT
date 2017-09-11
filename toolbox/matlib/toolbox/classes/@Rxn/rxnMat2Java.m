function glycanRxnJava = rxnMat2Java(obj )
%RXNMAT2JAVA convert a MATLAB RXN class to a Java GLYCANRXN class
%   
%  GLYCANRXNJAVA = RXNMAT2JAVA(RXNMATOBJ) reads the
%  RXN  object and returns a Java GLYCANRXN object. 
%  
%  GLYCANRXNJAVA = RxnObj.RXNMAT2JAVA is equivilent to GLYCANRXNJAVA
%  = RXNMAT2JAVA(RXNMATOBJ).
%
% See also RXN/RXN
if(~isempty(obj.reac))
    glycanSpecReacJava = obj.reac.speciesMat2Java;
else
    glycanSpecReacJava  =[];
end    

if(~isempty(obj.prod))
    glycanSpecProdJava = obj.prod.speciesMat2Java;
else
    glycanSpecProdJava  =[];
end    

glycanRxnJava = org.glyco.GlycanRxn(glycanSpecReacJava,glycanSpecProdJava);


end