function sbml_compt = compt2SBML(comptMat) 
%compt2SBML convert a Compt object to a SBML_compartment struture
% 
% See also Compt.

% Author: Gang Liu
% CopyRight 2012 Neelamegham Lab.

%convert to SBML level 3 and version 1

% if comptMat is empty, create a default compartment
if(isCompartmentEmpty(comptMat))
sbml_compt = Compartment_create(3,1);
if(isfield(sbml_compt,'setSpatialDimensions'))
sbml_compt.isSetSpatialDimensions=1;
end 
else 
sbml_compt = Compartment_create(3,1);
if(~isempty(comptMat.getSize))
sbml_compt = Compartment_setSize(sbml_compt,comptMat.getSize);
end
if(~isempty(comptMat.getSpatialDimensions))
sbml_compt = Compartment_setSpatialDimensions(...
sbml_compt,comptMat.getSpatialDimensions);
end
if (Compartment_isSetUnits(sbml_compt))
sbml_compt = Compartment_setUnits(sbml_compt,comptMat.getUnits);     
end 

if(~isempty(comptMat.getName))
sbml_compt = Compartment_setName(sbml_compt,comptMat.getName);
end     

% not sure if id should be included 
%  if(~isempty(comptMat.getID))
%  sbml_compt = Compartment_setId(sbml_compt,num2str(comptMat.getID));
%  end

end
end
