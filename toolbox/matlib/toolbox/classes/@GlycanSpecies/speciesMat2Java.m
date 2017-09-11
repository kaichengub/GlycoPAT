function glycanSpeciesJava = speciesMat2Java(obj )
%speciesMat2Java convert a MATLAB GlycanSpecies object to a Java GlycanSpecies object
%   
%  GLYCANSPECIESJAVA = SPECIESMAT2JAVA(GLYCANSPECIESOBJ) reads the
%   GLYCANSPECIES object and returns a Java GlycanSpecies object. 
%  
%  GLYCANSPECIESJAVA = GlycanSpeciesObj.SPECIESMAT2JAVA is equivilent to GLYCANSPECIESJAVA
%   = SPECIESMAT2JAVA(GlycanStructobj).
%
% See also GLYCANSPECIES/GLYCANSPECIES

GlycanStructJava   = obj.glycanStruct.structMat2Java;
glycanSpeciesJava  = org.glyco.GlycanSpecies(GlycanStructJava,GlycanStructJava.toString);
if(~isempty(obj.compartment))
   comptName = java.lang.String(obj.compartment.getName);
   glycanSpeciesJava.setCompartname(comptName);
end

end

