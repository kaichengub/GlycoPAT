function removeIsolatedSpecies(path)
%removeIsolatedSpecies remove the isolated species from the pathway
%
% removeIsolatedSpecies(path) find the isolated species and delete it/them
%  from the pathway if found in the network
%  
%  Example: 
%   pathexample = Pathway.loadmat('npathwithisolatedspecies.mat');
%   glycanPathViewer(pathexample);
%   removeIsolatedSpecies(pathexample);
%   glycanPathViewer(pathexample);
%
%See also detectIsolatedSpcies.

%Author: Gang Liu
%Date Last Updated: 8/2/13
narginchk(1,1);

if(~isa(path,'Pathway'))
    error('MATLAB:GNAT:InputWrong','Wrong Input Type');
end
numisolatedspecies=0;
isospeciesindex=[];

for i = 1 : path.getNSpecies
    inRxnNum   = path.theSpecies.get(i).listOfProdRxns.length;
    outRxnNum = path.theSpecies.get(i).listOfReacRxns.length;
    
    if((inRxnNum==0)&&(outRxnNum==0))
        isospeciesindex         = [isospeciesindex;i];
        numisolatedspecies = numisolatedspecies+1;
    end
end
if(numisolatedspecies>0)
    path.theSpecies.remove(isospeciesindex);
end

end
