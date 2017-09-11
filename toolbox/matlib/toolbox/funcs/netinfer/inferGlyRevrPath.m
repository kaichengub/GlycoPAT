function varargout = inferGlyRevrPath(prodObjArray,enzObjArray,varargin)
%inferGlyRevrPath infer the pathway based on enzymes and glycans as end-products.
%
%  [isPathwayFormed,pathway] = inferGlyRevrPath(prodObjArray,enzArray) infers
%    the pathway if enzymes acts on substrates. If no pathway is
%    formed, isPathwayFormed is false.
%
%  [isPathwayFormed,pathway] = inferGlyRevrPath(prodObjArray,enzArray,
%    'iterativedisp',isdisplay) displays the network at each iterative
%    step if isdisplay is true.
%   
%    Example: 
%       enzArray = CellArrayList;
%       mgat2     = GTEnz.loadmat('mgat2.mat'); enzArray.add(mgat2);
%       mgat3     = GTEnz.loadmat('mgat3.mat'); enzArray.add(mgat3);
%       mgat4     = GTEnz.loadmat('mgat4.mat'); enzArray.add(mgat4);
%       mgat5     = GTEnz.loadmat('mgat5.mat'); enzArray.add(mgat5);
%       galt          = GTEnz.loadmat('galt.mat'); enzArray.add(galt);
%       prodArray = CellArrayList; 
%       tetraprimglycan    = GlycanSpecies(glycanMLread('tetriprime_gal_nlinkedglycan.glycoct_xml')) ;
%       prodArray.add(tetraprimglycan);
%       fprintf(1,'Input of glycan product structure is \n');
%       glycanViewer(tetraprimglycan.glycanStruct);
%       [isPath,nlinkedpath]=inferGlyRevrPath(prodArray, enzArray);
%       fprintf(1,'Inferred network is shown below:\n');
%       glycanPathViewer(nlinkedpath);
%       
% See also inferGlyForwPath, inferGlyConnPath, inferGlySubstr.

% Author: Gang Liu
% Date Last Updated: 8/5/13

narginchk(2,4);

if(nargin==3)
    error('MATLAB:GNAT:InputNumberWrong','Wrong Input number');
end

if(~isa(prodObjArray,'CellArrayList'))
    error('MATLAB:GNAT:InputTypeWrong','Wrong Input Type');
end

if(~isa(enzObjArray,'CellArrayList'))
    error('MATLAB:GNAT:InputTypeWrong','Wrong Input Type');
end

iterativedisplay = false;

if(nargin==4)
    optionformat = varargin{1};
    if(strcmp(optionformat,'iterativedisp'))
        iterativedisplay = varargin{2};
    else
        error('MATLAB:GNAT:InputTypeWrong','Wrong Input Type');
    end
end

nargoutchk(1,2);

glypath  = Pathway;
substrObjCopy = prodObjArray;

numSpeciesToAdd = 1000;
count = 0;
while(numSpeciesToAdd~=0)
    % disp('number of times');
    
    count=count+1;
    if(count==5)
        disp(num2str(count));
    end
    newspeciesToAdd = inferPathgt1Glycangt1Enz(glypath,...
        substrObjCopy,enzObjArray);
    
    numSpeciesToAdd = length(newspeciesToAdd);
    if(numSpeciesToAdd>0)
        substrObjCopy = newspeciesToAdd;
        isPathwayFormed = 1;
        
        if(iterativedisplay)
            golgi   = Compt('golgi');
            name  = 'inferredPathway';
            gtestModel = GlycanNetModel(golgi,glypath,name);
            fprintf(1,'round:');
            disp(num2str(count));
            fprintf(1,'number of total species in the pathway: ');
            disp(num2str(glypath.theSpecies.length));
            fprintf(1,'number of total reactions in the pathway: ');
            disp(num2str(glypath.theRxns.length));
            glycanNetViewer(gtestModel);
        else
            fprintf(1,'round:');
            disp(num2str(count));
            fprintf(1,'number of total species in the pathway: ');
            disp(num2str(glypath.theSpecies.length));
            fprintf(1,'number of total reactions in the pathway: ');
            disp(num2str(glypath.theRxns.length));
        end
        
    end
end

if(nargout==1)
    varargout{1} = isPathwayFormed;
elseif(nargout==2)
    varargout{1} = isPathwayFormed;
    varargout{2} = glypath;
end

end

function  prodspeciesToAdd =...
    inferPathgt1Glycangt1Enz(glypath,multiGlycans,enzObjArray)

prodspeciesToAdd = CellArrayList;
numGlycans           = length(multiGlycans);

for i = 1 : numGlycans
    [newspeciesToAdd,newrxnsToAdd,newglypath] =...
        inferPathFrom1Glycangt1Enz(multiGlycans.get(i),enzObjArray) ;
    [newGlycans,newRxns,newEnzs]= ...
        glypath.addGlyPathByStruct(newglypath);
    prodspeciesToAdd=addGlycanSpeciesByStruct(...
        prodspeciesToAdd,newGlycans);
end

end

function  prodspeciesToAdd=addGlycanSpeciesByStruct(prodspeciesToAdd,newGlycans)
for i = 1: length(newGlycans)
    newglycan = newGlycans.get(i);
    locs=findsameStructGlycan(prodspeciesToAdd,newglycan);
    if(locs==0)
        prodspeciesToAdd.add(newglycan);
    end
end
end

function locs=findsameStructGlycan(theSpecies,glycanSpeciesObj)
%findsameStructGlycan find a GlycanSpecies object in the species
%list sharing the same structure
%
% locs =  findsameStructGlycan(glycanSpeciesObj) find the
% position of species sharing the same glyan structure.If not
% found, return 0.
%
%  See also Rxn,GlycanSpecies.
locs = 0;
for i = 1 : length(theSpecies)
    if(isequal(theSpecies.get(i).glycanStruct,glycanSpeciesObj.glycanStruct))
        locs=i;
        return  % assume only one same structure in the list
    end
end
end

function  [newspeciesToAdd,newrxnsToAdd,newglypath] =...
    inferPathFrom1Glycangt1Enz(singleGlycan,enzObjArray)

newspeciesToAdd = CellArrayList;
newrxnsToAdd      =  CellArrayList;
newglypath            =   Pathway;

for i=1:length(enzObjArray)
    %i
    %     if(i==6)
    %         disp('mgat');
    %     end
    
    singleEnz  = enzObjArray.get(i);
    [numProds,prodSpecies,rxns,glypath]...
        = inferGlySubstr(singleGlycan,singleEnz);
    
    %     for j=1:length(prodSpecies)
    %        glycanViewer(prodSpecies.get(j).glycanStruct);
    %     end
    
    [newspeciesToAdd,newrxnsToAdd,newEnzs]=...
        newglypath.addGlyPathByStruct(glypath);
end

end