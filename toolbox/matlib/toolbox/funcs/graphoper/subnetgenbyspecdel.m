function subpath = subnetgenbyspecdel(path,listofspeciesToRemove,varargin)
%SUBNETGENBYSPECDEL generate a list of subpath from a parent pathway by
% deleting specified species
%
% subpathObj = SUBNETGENBYSPECDEL(path,listofspeciestoremove) returns a
%   pathway object by removing user-specificed species from the pathway.
%
% subpathObj = SUBNETGENBYSPECDEL(path,listofspeciestoremove,'removeiso',true) 
%   returns a Pathway object where isolated species are removed.
%
%  Example: 
%        pathexample = Pathway.loadmat('nlinkedpath.mat');
%        glycanPathViewer(pathexample);
%        specieslisttoremove = CellArrayList;
%        m3gn      = GlycanSpecies(glycanMLread('m3gn.glycoct_xml'));
%        m3gngn = GlycanSpecies(glycanMLread('m3gngn.glycoct_xml'));
%        specieslisttoremove.add(m3gn);   specieslisttoremove.add(m3gngn);
%        subpath =   subnetgenbyspecdel(pathexample,specieslisttoremove);
%        glycanPathViewer(subpath);
%
%
%See also SUBNETGENBYNUMDEL,SUBNETGENBYSPECKEEP.

% Author: Gang Liu
% Date Last Updated: 8/2/13

if(~isa(path,'Pathway'))
    error('MATLAB:GNAT:WrongInput','Input Wrong Type');
end

if(~isa(listofspeciesToRemove,'CellArrayList'));
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

% specieslist  index
listtokeepindex =ones(path.getNSpecies,1);
for i =1 : length(listofspeciesToRemove)
    speciesloc  = path.findsameStructGlycan(listofspeciesToRemove.get(i));
    if(speciesloc~=0)
        listtokeepindex(speciesloc,1)=0;
    end
end

listindex = find(listtokeepindex);
listofsubspecies = path.theSpecies.get(listindex);
subspeciesinput = CellArrayList;
subspeciesinput.add(listofsubspecies);

subpath  =  subnetgenbyspeckeep(path,subspeciesinput,...
      'removeiso',hasisospeciesremoved);

end

