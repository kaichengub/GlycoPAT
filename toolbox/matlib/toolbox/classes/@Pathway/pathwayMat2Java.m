function glycanNetJava = pathwayMat2Java(obj)
%pathwayMat2Java convert a MATLAB Pathway object to a vector of Java GlycanNet objects
%   
%  GLYCANETJAVA = pathwayMat2Java(pathwayobj) reads a Pathway
%  object and returns a vector of Java GlycanNet objects. 
%  
%  GLYCANETJAVA = pathwayObj.pathwayMat2Java is equivilent to GLYCANETJAVA
%  = pathwayMat2Java(pathwayObj).
%
% See also PATHWAY/PATHWAY
import  org.eurocarbdb.application.glycanbuilder.*;

glycanNetRead = org.glyco.GlycanNetRead;

% set all species
for i=1:length(obj.theSpecies)
   % i
    glycanSpeciesJava = obj.theSpecies.get(i).speciesMat2Java;
    glycanNetRead.theGlycanSpecies.add(glycanSpeciesJava);    
    glycanNetRead.theGlycanArray.add(glycanSpeciesJava.getStructure);
    theKeyString = glycanSpeciesJava.getStructure.toStringOrdered(0);
    theKeyString = theKeyString.concat(glycanSpeciesJava.getCompartname);
    glycanNetRead.glycanIndexMap.put(theKeyString,glycanSpeciesJava);
end

% set all reactions
for i=1:length(obj.theRxns)
    glycanRxnMat = obj.theRxns.get(i);
    if(~isempty(glycanRxnMat.getReactant))
         reacRefKey=strcat(glycanRxnMat.getReactant.getGlycanStruct.toString,...
            glycanRxnMat.getReactant.compartment.getName);
        reacRef  = glycanNetRead.glycanIndexMap.get(java.lang.String(reacRefKey));
        if(isempty(reacRef))
            errorReport(mfilename,'codebug');
        end   
    else
        reacRef = [];
    end
    
    if(~isempty(glycanRxnMat.getProduct))
        %i 
        %glycanRxnMat.getProduct.getGlycanStruct 
        %glycanRxnMat.getProduct.getGlycanStruct.toString
        % glycanRxnMat.getProduct.compartment
        prodRefKey=strcat(glycanRxnMat.getProduct.getGlycanStruct.toString,...
             glycanRxnMat.getProduct.compartment.getName);
         prodRef = glycanNetRead.glycanIndexMap.get(java.lang.String(prodRefKey)); 
         if(isempty(prodRef))
            errorReport(mfilename,'codebug');
        end  
    else
         prodRef = [];
    end
    glycanRxnJava =  org.glyco.GlycanRxn(reacRef,prodRef);    
    glycanNetRead.theGlycanRxns.add(glycanRxnJava);    
end

% set all compartments
for i=1:length(obj.compartment)
    compt = obj.compartment.get(i);
    glycanNetRead.theCompartments.add(compt.getName);
end

glycanNetRead.readPathwayInCompts;
glycanNetJava = glycanNetRead.theGlycanRxnNets;
end