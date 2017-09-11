function glycanformula = glyformula(glycanstring)
%GLYFORMULA: Compute chemical formula of a glycan
%
% Syntax; 
%      glycanformula = glyformula(glycanstring)
%  
% Input:  
%      glycanstring: a string of the glycan in SmallGlyPep format
%
% Output: 
%      glycanformula: an object of MATLAB Chemformula class 
%         representing glycan chemical formula.
%
% Example: 
%      glycanformula = glyformula('{n{h{s}}{n{f}{h{s}}}}');
%      disp(glycanformula.cfstruct);
%   Answer:
%      C:56
%      H:92
%      O:41
%      N:4
%
%See also ptmformula,pepformula,glypepformula.

%Author: Gang Liu
%Date Lastly Updated: 8/4/2014

% create a container map storing 1 letter (key) and formula (value)
formulaMap     = Glycan.glycanformulaMap;
glycanformula  = Chemformula;

glycanstring   = regexprep(glycanstring,'[{}]','');
for i = 1 : length(glycanstring)
    eleformulaObj = Chemformula(formulaMap(glycanstring(i)));
    glycanformula.add(eleformulaObj);    
end

glycanformula.add(Chemformula(struct('H',2,'O',1)));  
end