function MassOPTJAVA = massOptMat2Java( objMat,varargin)
%MASSOPTMAT2JAVA convert a MATLAB MassOptions object to a Java MassOptions object
%   
%  MassOPTJAVA = MASSOPTMAT2JAVA(MASSOPTMAT) reads a MassOptions
%  object and returns a Java MASSOPTIONS object. 
%  
%  MassOPTJAVA = MASSOPTMAT.MASSOPTMAT2JAVA is equivalent to MASSOPTJAVA
%  = MASSOPTMAT2JAVA(MASSOPTMAT).
%
% See also MASSOPTIONS/MASSOPTIONS
import org.eurocarbdb.application.glycanbuilder.MassOptions;
import org.eurocarbdb.application.glycanbuilder.IonCloud;

MassOPTJAVA = org.eurocarbdb.application.glycanbuilder.MassOptions;
MassOPTJAVA.setIsotope(objMat.getIsoTope);
MassOPTJAVA.setDerivatization(objMat.getDerivatization);

if(~isempty(objMat.getRedEndType))
resEndTypeJava = objMat.getRedEndType.resTypeMat2Java;
MassOPTJAVA.setReducingEndType(resEndTypeJava)
end

if(~isempty(objMat.getIonCloud))
ioncloudString = java.lang.String(objMat.getIonCloud);
MassOPTJAVA.ION_CLOUD = org.eurocarbdb.application.glycanbuilder.IonCloud(ioncloudString);
end


end

