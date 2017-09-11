function decoysgp=fdrdecoy(varargin)
%FDRDECOY: Generate deocy glycopeptide for FDR computation
%
%Syntax: 
%   DecoySGP=fdrdecoy(SmallGlyPep,type)
%
% Input: 'SmallGlyPep' to be swapped, 'types' of modification:
% 1. 'first': flips the first and last a. acids
% 2. 'firstTwo': flips the first two a. acids with the last two
% 3. 'flip': Reverses input SmallGlyPep sequence
% 4. 'random': Randomizes the amino acids
%
% Output: 'DecoySGP' which is the modified SmallGlyPep output
%
% Example 1:
%   SmallGlyPep='M<o>{n{h{s}}}GHKL<o>FLM{n{h{s}}}L';
%   type='flip';
%   Decoy=fdrdecoy(SmallGlyPep, type)
%   Ans: LM{241.9748{147.3541{266.8986}}}LFL<o>KHGM<o>{183.8411{160.0191{312.3674}}}
%   % notes: the numbers in the bracket vary by each run since they are
%   randomly generated but their sum remains constant as 656.2275.
% 
% Example 2:
%   SmallGlyPep='M<o>{n{h{s}}}GHKL<o>FLM{n{h{s}}}L';
%   type='random';
%   Decoy=fdrdecoy(SmallGlyPep, type)
%   Ans:HFM<o>{214.0291{200.3728{241.8257}}}LM{192.891{164.0182{299.3184}}}L<o>KLG
%
%See also swapAacid, glycanDecoy, fdrfiler, fdr. 

% Author: Gang Liu
% Date Lastly Updated: 10/26/14 by Gang Liu

if(nargin==2)
    SmallGlyPep = varargin{1};
    type = varargin{2};
else
    error('MATLAB:GLYCOPAT:NUMINPUTERROR','INCORRECT INPUT NUMBER');
end

% swap amino acid
SmallGlyPep = swapAacid(SmallGlyPep,type);


% modify glycan composition
if(isempty(SmallGlyPep)) % if SmallGlyPep is glycan only
   SmallGlyPep = varargin{1};
end

[pepMat,glyMat,modMat]=breakGlyPep(SmallGlyPep);
numglycans = length(glyMat);

maxmwchange = 50;
for i = 1: numglycans
    glystring     = glyMat(1,i).struct; 
    glyresidues   = regexp(glystring,'(?<={)[^{}]+','match');
    glyresiduesmw = zeros(glyMat(1,i).len,1);
    for j = 1 : glyMat(1,i).len
        if double(glyresidues{j}(1)) < 123 && double(glyresidues{j}(1)) > 96
            glyresiduesmw(j)= Glycan.glycanMSMap(glyresidues{j});
        else
            glyresiduesmw(j)= str2double(glyresidues{j});
        end
    end
    mwchange_residues  = randfixedsum(glyMat(1,i).len,1,0,-1,1)*maxmwchange;
    mwchange_residues  = mwchange_residues + glyresiduesmw;  
    
    replacementstring  = cellstr(num2str(mwchange_residues));
    replacementstring  = strtrim(replacementstring);
    glyMat(1,i).struct = regexprep(glystring,'(?<={)[a-z]',replacementstring,'once');
end

decoysgp = joinGlyPep(pepMat,glyMat,modMat);
end
