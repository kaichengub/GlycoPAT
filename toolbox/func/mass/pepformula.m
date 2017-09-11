function pepformula = pepformula(pepstring)
%PEPFORMULA: Compute chemical formula of a peptide
%
% Syntax: 
%    pepformula = pepformula(pepseq) 
% 
% Input:  
%  pepseq: a string containing the peptide sequence
%
% Output: 
%  pepformula: an object of MATLAB Chemformula class 
%      representing peptide chemical formula.
%
% Example: 
%   pepformula = pepformula('GKRKDE');
%   disp(pepformula.cfstruct);
%   Answer:
%     C: 29
%     H: 53
%     N: 11
%     O: 11
%
%See also pepMW,glyformula,ptmformula,glypepformula.

% Author: Gang Liu
% Date Lastly Updated: 8/10/2014

% load a container map 
mapObj     = Aminoacid.formulaMap;
pepformula = Chemformula;

for i=1:length(pepstring)
    eleformula = mapObj(upper(pepstring(i)));
    pepformula.add(Chemformula(eleformula));
end

h2oformula = Chemformula(struct('h',2,'o',1));
h2oformula.multiply(length(pepstring)-1);
pepformula.sub(h2oformula);

end