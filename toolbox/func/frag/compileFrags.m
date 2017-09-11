function AllFragIons=compileFrags(protProd,glyBion,glyYion,pepBion,pepCion,pepIion,pepYion,pepZion)
%COMPILEFRAGS: Generate 'AllFragIons' by appending the structures protProd, glyBion,
%   glyion, pepBion, pepCion, pepIion, pepYion and pepZion.
%
% Syntax:  
%   AllFragIons=compileFrags(protProd,glyBion,glyYion,pepBion,pepCion,pepIion,pepYion,pepZion)
%  
% Input: 
%   Individual structures containing information about B, Y, C and Z ions
%
% Output:
%   Consolidated AllFragIons structure with information about all
%   ions
%
% * Children function: UQFragIon
%
%See also UQFRAGION, COMPILEFRAGS, JOINGLYPEP, GLYCANFRAG, BREAKGLYPEP,
%MULTISGPFRAG. 

% Author: Sriram Neelamegham
% Date Lastly Updated: 08/11/14
 
AllFragIons=[];
AllFragIons=[AllFragIons;protProd];  % There is always something in protProd
if length(glyBion)>0
    glyBion=UQFragIon(glyBion); % removed duplication of elements
    AllFragIons=[AllFragIons,glyBion];
end
if length(glyYion)>0
    glyYion=UQFragIon(glyYion); % removed duplication of elements
    AllFragIons=[AllFragIons,glyYion];
end
if ~isempty(pepBion)
    if (~isempty(pepBion(1).mz))
        pepBion=UQFragIon(pepBion); % removed duplication of elements
        AllFragIons=[AllFragIons,pepBion];
    end
end
if ~isempty(pepCion)
    if (~isempty(pepCion(1).mz))
        pepCion=UQFragIon(pepCion); % removed duplication of elements
        AllFragIons=[AllFragIons,pepCion];
    end
end
if ~isempty(pepIion)
    if (~isempty(pepIion(1).mz))
        pepIion=UQFragIon(pepIion); % removed duplication of elements
        AllFragIons=[AllFragIons,pepIion];
    end
end
if ~isempty(pepYion)
    if (~isempty(pepYion(1).mz))
        pepYion=UQFragIon(pepYion); % removed duplication of elements
        AllFragIons=[AllFragIons,pepYion];
    end
end
if ~isempty(pepZion)
    if (~isempty(pepZion(1).mz))
        pepZion=UQFragIon(pepZion); % removed duplication of elements
        AllFragIons=[AllFragIons,pepZion];
    end
end
end