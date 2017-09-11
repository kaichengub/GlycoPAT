function residueJava = residueMat2Java(obj)
%RESIDUEMAT2JAVA convert a MATLAB GlycanResidue object to a Java Residue object
%   
%  RESIDUEJAVA = RESIDUEMAT2JAVA(RESIDUEOBJ) reads a MATLAB GlycanResidue object and
%   returns a Java Residue Object. 
%
%  RESIDUEJAVA = RESIDUEOBJ.RESIDUEMAT2JAVA is equivilent to ESIDUEJAVA = RESIDUEMAT2JAVA(RESIDUEOBJ) 
%
% See also GLYCANRESIDUE/GLYCANRESIDUE, GLYCANSTRUCT/GLYCANSTRUCT
    
 %  Author: Gang Liu
 %   CopyRight@ Neelamegham Lab.
  
 % input check
% if(~verLessThan('matlab','7.13'))
%     narginchk(0,1);
% else
%     error(nargchk(0,1,nargin));
% end
    
import org.eurocarbdb.application.glycanbuilder.Residue;
import java.util.Vector;

if  (~isempty(obj) && ~isempty(getResidueType(obj)))
    resTypeMat = getResidueType(obj);
    resTypeJava = resTypeMat2Java(resTypeMat);
    anomeric_state = getAnomericState(obj);
    anomeric_carbon = getAnomericCarbon(obj);
    chirality = getChirality(obj);
    ringSize = getRingSize(obj);
    
    residueJava = Residue(resTypeJava,anomeric_state,anomeric_carbon,chirality,ringSize);
    
    %set up linkage information
    linkage_children = getLinkageChildren(obj);
    numChildren = size(linkage_children,1);
                 
    %retrieve linkage information
    for i = 1: numChildren
        linkageMat = linkage_children(i,1);
        resChildJava = residueMat2Java(linkageMat.getChild);
        bonsMat = linkageMat.getBonds;
        numBonds = size(bonsMat,1);
        bondsJavaList = java.util.Vector;
              
        for j=1:numBonds
                bondJava = bondMat2Java(bonsMat(j,1));
                bondsJavaList.add(bondJava);
        end
        residueJava.insertChildAt(resChildJava,bondsJavaList,i-1);        % parent linkage set up in java inherently
    end
    
else
     residueJava = Residue;
end

end

