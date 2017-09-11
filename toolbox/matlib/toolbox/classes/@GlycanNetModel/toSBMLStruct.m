function sbmlstruct = toSBMLStruct(obj)
%toSBMLStruct returns a SBML structure
%   
%  Example:   
%       glycanNetExampleFileName = 'gnat_test_wtannot.xml';
%       glycanNetModelObj               =  glycanNetSBMLread(...
 %      glycanNetExampleFileName);
%       smblstruct                               = glycanNetModelObj.toSBMLStruct;
%    
% See also GLYCANNETMODEL.

% Author: Gang Liu
% Date Lastly Updated: 9/30/13

% default SBML level and version L2V1
defaultlevel = 2;
defaultver   = 1;
sbmlstruct  = Model_create(defaultlevel,defaultver);

% add compartment info to SBML 
numCompt = length(obj.getCompartment);
for i=1 : numCompt
    % set up each compartment
    ithcompt    = obj.getCompartment.get(i);
   sbmlcompt = setSBMLCompt(ithcompt,defaultlevel,defaultver,i); 
   sbmlstruct   = Model_addCompartment(sbmlstruct, sbmlcompt);   
end

% add species info to SBML
numSpecies = obj.getGlycanPathway.getNSpecies;
for i = 1 : numSpecies
    % set up each species
    ithspecies     = obj.getGlycanPathway.getSpecies.get(i);
    sbmlspecies = setSBMLSpecies(ithspecies,defaultlevel,defaultver,i);
    sbmlstruct   = Model_addSpecies(sbmlstruct,sbmlspecies);   
end

% add reaction info to SBML
numRxns = obj.getGlycanPathway.getNReactions;
for i = 1 : numRxns
    % set up each species
    ithRxn            = obj.getGlycanPathway.getReactions.get(i);
    sbmlrxn         = setSBMLRxn(ithRxn,defaultlevel,defaultver,i);    
    sbmlstruct    = Model_addReaction(sbmlstruct, sbmlrxn);   
end

end

% set up sbml rxn
function sbmlrxn = setSBMLRxn(ithrxn,defaultlevel,defaultver,i)
    sbmlrxn = Reaction_create(defaultlevel,defaultver);
    
    % set reaction name
    if(isprop(ithrxn,'name') && ~isempty(ithrxn.name))
        sbmlrxn = Reaction_setName(sbmlrxn,ithrxn.name);
    else
        ithrxnname = ['rxn' num2str(i)];
        sbmlrxn = Reaction_setName(sbmlrxn,ithrxnname);
    end
    
    % set reaction id
    if(isprop(ithrxn,'id') && ~isempty(ithrxn.id))
        sbmlrxn = Compartment_setId(sbmlrxn,ithrxn.ID);
    else
        ithrxnid = ['rxn' num2str(i)];
        sbmlrxn = Reaction_setId(sbmlrxn,ithrxnid);
    end
    
    % set reactant reference
    if(isprop(ithrxn,'reac')&&~isempty(ithrxn.reac))
        sbmlreactant               = SpeciesReference_create(defaultlevel, defaultver);
        if(~isempty(ithrxn.reac.id))
           reacspeciesid            = ithrxn.reac.id;
        else
           reacspeciesid           = ['species' num2str(i)];
        end
        sbmlreactant.species  = reacspeciesid;
        sbmlrxn                      = Reaction_addReactant(sbmlrxn, sbmlreactant);
    end
     
    % set product reference
    if(isprop(ithrxn,'prod') && ~isempty(ithrxn.prod))
        sbmlproduct = SpeciesReference_create(defaultlevel, defaultver);
        if(~isempty(ithrxn.prod.id))
           prodspeciesid  = ithrxn.prod.id;
        else
           prodspeciesid  = ['species' num2str(i)];
        end
        sbmlproduct.species  = prodspeciesid;
        sbmlrxn             = Reaction_addProduct(sbmlrxn, sbmlproduct);
    end
end

% set up sbml species
function sbmlspecies = setSBMLSpecies(ithspecies,defaultlevel,defaultver,i)
    sbmlspecies = Species_create(defaultlevel,defaultver);
    
    % set species name
    if(~isempty(ithspecies.name))
      sbmlspecies = Species_setName(sbmlspecies,ithspecies.name);
    else
      newname =  ['species' num2str(i)];
      sbmlspecies = Species_setName(sbmlspecies,newname);
    end
    
    % set species id
    if(isprop(ithspecies,'id')&&~isempty(ithspecies.id))
        sbmlspecies = Compartment_setId(sbmlspecies,ithspecies.id);
    else
        newid =  ['s' num2str(i)];
        sbmlspecies = Species_setId(sbmlspecies,newid);
    end
    
    % set compartment name
    if(isprop(ithspecies,'compartment')&&~isempty(ithspecies.compartment))
        comptname   = ithspecies.compartment.name;
        sbmlspecies = Species_setCompartment(sbmlspecies,comptname);
    end
    
    % set structure annotation for sbml
    glycostr             = glycanStrwrite(ithspecies.glycanStruct);
    annotationstr   = setAnnotationStr(glycostr);
    sbmlspecies.annotation =  annotationstr;    
end

function annotationstr=setAnnotationStr(glycostr)
    annotationstr=['<annotation>' ...
                     '<glycoct xmlns="http://www.eurocarbdb.org/recommendations/encoding">'];
    annotationstr =[annotationstr glycostr '</glycoct>' '</annotation>'];
    annotationstr=strrep(annotationstr,'<?xml version="1.0" encoding="UTF-8"?>', ' ');
end

% set up sbml compartment
function sbmlcompt = setSBMLCompt(ithcompt,defaultlevel,defaultver,i)
    sbmlcompt = Compartment_create(defaultlevel,defaultver);
    
    % set compartment name
     if(~isempty(ithcompt.name))
        sbmlcompt = Compartment_setName(sbmlcompt,ithcompt.name);
     else
        newcomptname =  ['compt' num2str(i)];
        sbmlcompt = Compartment_setName(sbmlcompt,newcomptname);
     end    
   
    % set compartment id
    if(isprop(ithcompt,'id') && ~isempty(ithcompt.id))
        sbmlcompt = Compartment_setId(sbmlcompt,num2str(ithcompt.id));    
    else
        newcomptid =  ['c' num2str(i)];
        sbmlcompt = Compartment_setId(sbmlcompt,newcomptid);        
    end
    
    % set compartment units
    if(isprop(ithcompt,'units')&& ~isempty(ithcompt.units))
        sbmlcompt = Compartment_setUnits(sbmlcompt,ithcompt.units);
    end   
    
    % set compartment size
    if(isprop(ithcompt,'size')&& ~isempty(ithcompt.size))
        sbmlcompt = Compartment_setSize(sbmlcompt,ithcompt.size);
    end
     
    % set compartment spatial dimensions
    if(isprop(ithcompt,'spatialdimensions') ...
            && ~isempty(ithcompt.spatialdimensions))
        sbmlcompt = Compartment_setSpatialDimensions(sbmlcompt,...
            (ithcompt.spatialdimensions));
    end 
    
end