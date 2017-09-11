function decoysgp=glycanDecoy(varargin)
%GLYCANDECOY: Generate decoy glycan for FDR computation
%
%Syntax: 
%   decoyglycansgp=glycandecoy(glycansgp)
%
% Input: 
%   glycansgp: glycan SmallGlyPep format
% 
% Output: 
%   decoyglycansgp: decoy glycan SmallGlyPep format
%
% Example 1:
%   glycansgp1 ='{n{h{s}}}';
%   Decoy=glycanDecoy(glycansgp1)
%   disp(Decoy)
%   
%   Ans: {220.1253{162.8245{273.2778}}}
%    
%   % notes: the numbers in the bracket vary by each run since they are
%   randomly generated but their sum remains constant as 656.2275.
%
%See also fdrdecoy,swapAacid. 

% Author: Gang Liu
% Date Lastly Updated: 04/05/15 by Gang Liu

if(nargin==1)
    glystring = varargin{1};
else
    error('MATLAB:GLYCOPAT:NUMINPUTERROR','INCORRECT INPUT NUMBER');
end

glyresidues   = regexp(glystring,'(?<={)[a-z]','match');
glyresiduesmw = zeros(length(glyresidues),1);
maxmwchange = 50;
for j = 1 : length(glyresidues)
   glyresiduesmw(j)= Glycan.glycanMSMap(glyresidues{j});
end
mwchange_residues  = randfixedsum(length(glyresidues),1,0,-1,1)*maxmwchange;
mwchange_residues  = mwchange_residues + glyresiduesmw;  

replacementstring  = cellstr(num2str(mwchange_residues));
replacementstring  = strtrim(replacementstring);
decoysgp = regexprep(glystring,'(?<={)[a-z]',replacementstring,'once');
end
