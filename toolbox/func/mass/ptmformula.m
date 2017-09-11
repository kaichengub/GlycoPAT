function modformula = ptmformula(modstring)
%PTMFORMULA: Compute chemical formula of PTM modification
%
% Syntax: 
%     ptmformula = ptmformula(modtype)  
% 
% Input:  
%     modtype: single letter representing type of modification
%
% Output: 
%     modformula:an object of MATLAB Chemformula class 
%      representing modification chemical formula.
%
% Example: 
%       modformula = ptmformula('s')
%       disp(modformula.cfstruct)
%     Answer:
%       S:1
%       O:3
%
%See also glyformula,pepformula,glypepformula.

% Author: Gang Liu
% Date Lastly Updated: 8/5/2014

% load a container map storing 1 letter and formula
formulaMap  = Modification.formulaMap;
mwEffectMap = Modification.mwEffectMap;
modformula  = Chemformula;

for i=1:length(modstring)
    eleformulaObj = Chemformula(formulaMap(modstring(i)));
    if(mwEffectMap(modstring(i)))  % add 
      modformula.add(eleformulaObj);
    else  % subtract
      modformula.sub(eleformulaObj);
    end    
end

end