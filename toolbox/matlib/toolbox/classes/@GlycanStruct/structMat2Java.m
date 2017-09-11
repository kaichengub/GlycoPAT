function glycanJava = structMat2Java(obj )
%structMat2Java convert a MATLAB GlycanStruct object to a Java Glycan object
%   
%  GLYCANJAVA = structMat2Java(GlycanStructobj) reads the GlycanStruct
%  object and returns a Java Glycan object. 
%  
%  GLYCANJAVA = GlycanStructobj.structMat2Java is equivilent to GLYCANJAVA
%  = structMat2Java(GlycanStructobj).
%
% See also GLYCANSTRUCT/GLYCANSTRUCT
import  org.eurocarbdb.application.glycanbuilder.*;

glycanJava = Glycan();
if(~isempty(obj.getRoot))
    root = residueMat2Java(obj.getRoot);
    glycanJava.setRoot(root);
end

% glycanstring = glycanJava.toGlycoCT;
% 
% % set up glycan document store
% workspace = org.eurocarbdb.application.glycanbuilder.BuilderWorkspace;
% glyDoc       = org.eurocarbdb.application.glycanbuilder.GlycanDocument(workspace);
% 
% try
%     glyDoc.importFromString(glycanstring,'glycoct_xml');
% catch exception
%     rethrow(exception);
%     error('MATLAB:GNAT:IMPORTERROR','Incorrect Stucture File');
% end
% glycanJava = glyDoc.getFirstStructure;

%  leave for future development
%----------------------------------------------
% if  (~isempty(obj) && ~isempty(getResidueType((obj.getBracket))))
%     bracket = resMat2Java(obj.getBracket);
%     glycanJava.addBracket(bracket);
% end
%----------------------------------------------

if(~isempty(obj.getMassOptions))
    mass_opt = massOptMat2Java(obj.getMassOptions);
    glycanJava.setMassOptions(mass_opt);
end



end

