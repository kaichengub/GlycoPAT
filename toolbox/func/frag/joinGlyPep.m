function SmallGlyPep=joinGlyPep(pepMat,glyMat,modMat)
%JOINGLYPEP: Reconstruct the glycopeptide using information provided in 
%  pepMat, glyMat and modMat.    
%  
%  Syntax: SmallGlyPep=joinGlyPep(pepMat,glyMat,modMat)
% 
% Input: Structures pepMat (peptide), glyMat (glycan) and modMat (PTMs)
%   pepMat stores peptide sequence (.pep) and position (.pos) data
%   glyMat stores glycan structure (.struct), position (.pos) on base peptide
%   and glycan length (.len) info
%   modMat stores PTM modification (.struct) and position (.pos) on base peptide
%   This works even if 1-2 of the above structures are provided and the rest
%   are empty.
%
% Output: SmallGlyPep (Can be glycopeptide, peptide or glycan) 
% 
%
% Example:
% Run breakGlyPep first to generate pepMat,GlyMat and ModMat. Then run this
% program
% >> SmallGlyPep='{n{h{s}}{n{h{s}{f}}}}';
%    [pepMat,glyMat,modMat]=breakGlyPep(SmallGlyPep)
%    joinGlyPep(pepMat,glyMat,modMat)
% Answer:
%       pepMat =    pep: ''
%                   pos: 0
%       glyMat =    pos: 0
%                   struct: '{n{h{s}}{n{h{s}{f}}}}'
%                   len: 7
%       modMat =    []
%       ans ={n{h{s}}{n{h{s}{f}}}}
% 
%See also BREAKGLYPEP, COMPILEFRAGS, GLYCANFRAG, UQFRAGION, MULTISGPFRAG.

% Author: Sriram Neelamegham
% Date Lastly Updated: 08/11/14 by Gang Liu.

npep=length(pepMat);
if (npep==1)
    SmallGlyPep=pepMat(1).pep;
    aacidPos=1:length(pepMat(1).pep);
    for i=length(glyMat):-1:1
        SmallGlyPep=strcat(SmallGlyPep(1:glyMat(i).pos),glyMat(i).struct,...
            SmallGlyPep(glyMat(i).pos+1:end));
        aacidPos(glyMat(i).pos+1:end)=aacidPos(glyMat(i).pos+1:end)+...
            length(glyMat(i).struct);
    end
    for i=length(modMat):-1:1
        SmallGlyPep=[SmallGlyPep(1:aacidPos(modMat(i).pos)),...
            modMat(i).struct,SmallGlyPep(aacidPos(modMat(i).pos)+1:end)];
    end
else         % this is a glycan without a peptide
    SmallGlyPep=glyMat(1).struct;
end
end
