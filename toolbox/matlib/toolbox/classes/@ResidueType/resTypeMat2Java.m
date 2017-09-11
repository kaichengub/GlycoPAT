function resTypeJava = resTypeMat2Java(obj)
    % RESTYPEMAT2JAVA convert a Matlab RESIDUETYPE object to a Java
    % RESIDUETYPE object
    % 
    %     RTJAVA = RESTYPEMAT2JAVA(RTMAT);
    %
    % See also RESIDUETYPE  

    strRes = resTypetoString(obj);
    strResJava = java.lang.String(strRes);
    resTypeJava = org.eurocarbdb.application.glycanbuilder.ResidueType(strResJava);
end


