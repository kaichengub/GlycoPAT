function isolatedspecies=detectIsolatedSpecies(path)
%detectIsolatedSpecies detect the isolated species in the pathway
%
% isolatedspecies = detectIsolatedSpecies(path) finds the isolated 
%   species and stores it/them in an array of GlycanSpecies objects.
%   If not found, isolatedspecies is returned empty. 
%   
%  Example: 
%       pathexample = Pathway.loadmat('npathwithisolatedspecies.mat');
%       glycanPathViewer(pathexample);
 %      isospecies = detectIsolatedSpecies(pathexample);
 %      for i = 1 : length(isospecies)
 %              glycanViewer(isospecies(i,1).glycanStruct);
 %      end
%      
%See also removeIsolatedSpecies.

% Author: Gang Liu
% Date Last Updated: 8/2/13
narginchk(1,1);

if(~isa(path,'Pathway'))
    error('MATLAB:GNAT:InputWrong','Wrong Input Type');
end
isospeciesindex=[];

for i = 1 : path.getNSpecies
    inRxnNum   = path.theSpecies.get(i).listOfProdRxns.length;
    outRxnNum = path.theSpecies.get(i).listOfReacRxns.length;
    
    if((inRxnNum==0)&&(outRxnNum==0))
        isospeciesindex  = [isospeciesindex;i];
    end
end
if(~isempty(isospeciesindex))
    isolatedspecies=path.theSpecies.get(isospeciesindex);
else
    isolatedspecies = [];
end

end
