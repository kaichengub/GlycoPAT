function varargout = inferGlyForwPath(substrObjArray,enzObjArray,varargin)
%inferGlyForwPath infer the pathway based on enzymes and glycans as starting structures.
%
%  [isPathwayFormed,pathway] = inferGlyForwPath(substrateArray,enzArray)
%    infers the pathway if enzymes act on substrates. If no pathway is
%    formed, isPathwayFormed is false.
%
%  [isPathwayFormed,pathway] = inferGlyForwPath(substrateArray,enzArray,
%    'iterativedisp',isdisplay) displays the network at each iterative
%    step if isdisplay is set as true.
%    
%    Example: 
%         enzArray       = CellArrayList;
%         mani    = GHEnz.loadmat('mani.mat');
%         enzArray.add(mani);
%         m9species    = GlycanSpecies(glycanMLread('M9.glycoct_xml')) ;
%         substrateArray = CellArrayList;
%         substrateArray.add(m9species);
%         fprintf(1,'Initial substrate structure is shown as below:');
%         glycanViewer(m9species.glycanStruct); 
%         [isPath,man1path]=inferGlyForwPath(substrateArray, enzArray);
%         fprintf(1,'Network inferred from M9 substrate catalyzed by ManI is shown as below:\n'); 
%         glycanPathViewer(man1path);
% 
% See also inferGlyRevrPath,inferGlyConnPath,inferGlyProd.

% Author: Gang Liu
% Date Last Updated: 8/2/13

narginchk(2,4);

if(nargin==3)
    error('MATLAB:GNAT:InputNumberWrong','Wrong Input number');
end

if(~isa(substrObjArray,'CellArrayList'))
    error('MATLAB:GNAT:InputWrong','Wrong Input Type');
end

if(~isa(enzObjArray,'CellArrayList'))
    error('MATLAB:GNAT:InputWrong','Wrong Input Type');
end

iterativedisplay = false;

if(nargin==4)
    optionformat = varargin{1};
    if(strcmp(optionformat,'compositioin'))
        maxProdComposition = varargin{2};  % product composition structure
    elseif(strcmp(optionformat,'structure'))
        maxProdSpecies = varargin{2};
    elseif(strcmp(optionformat,'iterativedisp'))
        iterativedisplay = varargin{2};
    else
        error('MATLAB:GNAT:InputWrong','Wrong Input');
    end
end

nargoutchk(1,2);

glypath  = Pathway;
substrObjCopy = substrObjArray;

numSpeciesToAdd = 1000;
count = 0;
while(numSpeciesToAdd~=0)
    % disp('number of times');
    
    count=count+1;
    newspeciesToAdd = inferPathgt1Glycangt1Enz(glypath,...
        substrObjCopy,enzObjArray);
       
    numSpeciesToAdd = length(newspeciesToAdd);
    if(numSpeciesToAdd>0)
        substrObjCopy = newspeciesToAdd;
        isPathwayFormed = 1;
        
        if(iterativedisplay)
            golgi   = Compt('golgi');
            name  = 'checkInfer';
            gtestModel = GlycanNetModel(golgi,glypath,name);
            fprintf(1,'\nround:');
            disp(num2str(count));
            fprintf(1,'number of total species in the pathway: ');
            disp(num2str(glypath.theSpecies.length));
            fprintf(1,'number of total reactions in the pathway: ');
            disp(num2str(glypath.theRxns.length));
            glycanNetViewer(gtestModel);
        else
            fprintf(1,'\nround:');
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
    singleEnz  = enzObjArray.get(i);
    [numProds,prodSpecies,rxns,glypath]...
        = inferGlyProd(singleGlycan,singleEnz);
 
    [newspeciesToAdd,newrxnsToAdd,newEnzs]=...
        newglypath.addGlyPathByStruct(glypath);
end

end