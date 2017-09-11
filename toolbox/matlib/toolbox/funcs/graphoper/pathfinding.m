function linkpath = pathfinding(path,pairofspecies)
%PATHFINDING find a pathway joining two species in a parent pathway
%
% linkpath = PATHFINDING(path,pairofspecies) returns a Pathway object
%  linkpathObj linking one species to another. pairofspecies is a MATLAB
%  structure with 'react' and 'prod' properties.
%
%    Example: 
%      pathexample = Pathway.loadmat('nlinkedpath.mat');
%      glycanPathViewer(pathexample);
%       % define two nodes 
%      tetraprimeglycan  = GlycanSpecies(...
%            glycanMLread('tetriprime_gal_nlinkedglycan.glycoct_xml')) ;
%      m3gngnlowerglycan = GlycanSpecies(...
%      glycanMLread('m3gngnlowerglycan.glycoct_xml'));
%      pair=struct('react',m3gngnlowerglycan,'prod',tetraprimeglycan);
%      pathfound=pathfinding(pathexample,pair);
%      glycanPathViewer(pathfound);
%
%See also SUBNETGENBYSPECKEEP,SUBNETGENBYSPECDEL,SUBNETGENBYNUMDEL.

%Author: Gang Liu
%Date Last Updated: 8/2/13
narginchk(2,2);
nargoutchk(1,1);

if(~isa(path,'Pathway'))
    error('MATLAB:GNAT:WrongInput','Input Wrong Type');
end

% if(~isa(pairofspecies,'CellArrayList'));
%     error('MATLAB:GNAT:WrongInput','Input Wrong Type');
% end

% if(pairofspecies.length~=2)
%     error('MATLAB:GNAT:WrongNOSpecies','Number of species input is 2');
% end

linkpath = path.clone;
rxns     = linkpath.theRxns;

linkpath.clearSpeciesMark;

% set initial species as visited
reactspecies   = pairofspecies.react;
prodspecies    = pairofspecies.prod;

initialspecies = findSpeciesByStruct(linkpath,reactspecies);
if(isempty(initialspecies))
    error('MATLAB:GNAT:WrongInput','Initial Substrate Glycan Not Found')
end
initialspecies.visited;

prodspecies  = findSpeciesByStruct(linkpath,prodspecies);
if(isempty(prodspecies))
    error('MATLAB:GNAT:WrongInput','Final Product Glycan Not Found')
end

graphDFSForward(initialspecies);
graphDFSReverse(prodspecies);

% check if path can be found
if(~prodspecies.mark)
    linkpath =[];
    return;
end

removespecieslocs = [];
numSpecies = linkpath.getNSpecies;

for i=1:numSpecies
    isspeciestokeep = (linkpath.theSpecies.get(i).mark && ...
        strcmpi(linkpath.theSpecies.get(i).markState,'yellow'));
    
    if(isspeciestokeep)
        % disp(i);
        linkpath.theSpecies.get(i).mark=true;
    else
        linkpath.theSpecies.get(i).mark=false;
    end   
    
    if(~isspeciestokeep)
        removespecieslocs = [removespecieslocs;i];   
    end
end

removerxnlocs=[];
for i = 1 : rxns.length
    therxn = rxns.get(i);
    reac   = therxn.reac;
    prod   = therxn.prod;
    if  (~ (reac.mark && prod.mark))
        removerxnlocs=[removerxnlocs;i];
    end    
end

% remove species
if(~isempty(removespecieslocs))
    linkpath.theSpecies.remove(removespecieslocs);
end

% remove rxns
if(~isempty(removerxnlocs))
    linkpath.theRxns.remove(removerxnlocs);
end

%reset reaction link in species
for  i = 1 : linkpath.getNSpecies;
    thespecies = linkpath.theSpecies.get(i);
    thespecies.listOfProdRxns=CellArrayList;
    thespecies.listOfReacRxns=CellArrayList;
    for j = 1:  linkpath.getNReactions;
        therxn=linkpath.theRxns.get(j);
        if(thespecies.eq(therxn.reac))
            thespecies.listOfReacRxns.add(therxn);
        elseif(thespecies.eq(therxn.prod))
            thespecies.listOfProdRxns.add(therxn);
        end
    end
end

linkpath.clearSpeciesMark;
end

function graphDFSForward(initialspecies)
initialspecies.visited;

% glycanViewer(initialspecies.glycanStruct);
for i = 1 : length(initialspecies.listOfReacRxns)
    ithrxn = initialspecies.listOfReacRxns.get(i);
    connectednode = ithrxn.prod;
    graphDFSForward(connectednode);
end

end

function graphDFSReverse(initialspecies)

if(~isprop(initialspecies,'markState') ||...
        isempty(initialspecies.markState))
    initialspecies.markState='yellow';
end;

for i = 1 : length(initialspecies.listOfProdRxns)
    ithrxn = initialspecies.listOfProdRxns.get(i);
    connectednode = ithrxn.reac;
    graphDFSReverse(connectednode);
end

end

