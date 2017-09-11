function subpath = subnetgenbyspeckeep(path,listofsubspeciestokeep,varargin)
%SUBNETGENBYSPECKEEP create a subpath from a pathway by selecting species to
% be kept
%
% subpath = SUBNETGENBYSPECKEEP(path,listofspecies) returns a
%    Pathway object subpath by keeping user-specified species
%    listofspecies in the Pathway path.
%
% subpath = SUBNETGENBYSPECKEEP(path,listofspecies,'removeiso',true)
%    returns a Pathway object subpath where isolated species are removed.
%
%   Example: 
%           pathexample = Pathway.loadmat('nlinkedpath.mat');
%          glycanPathViewer(pathexample);
%          specieslisttokeep = CellArrayList;
%          m3gn      = GlycanSpecies(glycanMLread('m3gn.glycoct_xml'));
%          m3gngn = GlycanSpecies(glycanMLread('m3gngn.glycoct_xml'));
%          specieslisttokeep.add(m3gn);   specieslisttokeep.add(m3gngn);
%          subpath =   subnetgenbyspeckeep(pathexample,specieslisttokeep);
%          glycanPathViewer(subpath);
% 
 % See also SUBNETGENBYSPECDEL,SUBNETGENBYNUMDEL.

% Author: Gang Liu
% Date Last Updated: 8/5/13
narginchk(2,4);
nargoutchk(1,1);

if(~isa(path,'Pathway'))
    error('MATLAB:GNAT:WrongInput','Input Wrong Type');
end

if(~isa(listofsubspeciestokeep,'CellArrayList'));
    error('MATLAB:GNAT:WrongInput','Input Wrong Type');
end

if(length(varargin)==2)
    if(strcmp(varargin{1},'removeiso')&&islogical(varargin{2}))
        hasisospeciesremoved = varargin{2};
    else
        hasisospeciesremoved = false;
    end
else
    hasisospeciesremoved = false;
end

subpath = path.clone;
rxns = path.theRxns;
path.clearSpeciesMark;

% add same species to subpath
for i = 1 : listofsubspeciestokeep.length
    specieslocs = path.findsameStructGlycan(...
        listofsubspeciestokeep.get(i));
    if(specieslocs~=0)
        species = path.theSpecies.get(specieslocs);
        species.visited;
    end
end

removespecieslocs = [];
numSpecies = path.getNSpecies;
for i=1:numSpecies
    if(~path.theSpecies.get(i).mark)
        removespecieslocs=[removespecieslocs;i];
    end
end

removerxnlocs=[];
for i = 1 : rxns.length
    therxn = rxns.get(i);
    reac   = therxn.reac;
    prod   = therxn.prod;
    if  (~(reac.mark&&prod.mark))
        removerxnlocs=[removerxnlocs;i];
    end
end
if(~isempty(removespecieslocs))
    subpath.theSpecies.remove(removespecieslocs);
end
if(~isempty(removerxnlocs))
    subpath.theRxns.remove(removerxnlocs);
end

%reset reaction link in species
for  i = 1 : subpath.getNSpecies;
    thespecies = subpath.theSpecies.get(i);
    thespecies.listOfProdRxns=CellArrayList;
    thespecies.listOfReacRxns=CellArrayList;
    for j = 1:  subpath.getNReactions;
        therxn=subpath.theRxns.get(j);
        if(thespecies.eq(therxn.reac))
            thespecies.listOfReacRxns.add(therxn);
        elseif(thespecies.eq(therxn.prod))
            thespecies.listOfProdRxns.add(therxn);
        end
    end
end

if(hasisospeciesremoved)
    removeIsolatedSpecies(subpath);
end

path.clearSpeciesMark;

end

