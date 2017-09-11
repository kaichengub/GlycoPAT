function varargout = glypepformula(SmallGlyPep)
%GLYPEPFORMULA: Compute chemical formula, monoisotopic and mostAbundant 
% mass of a glycopeptide in SmallGlyPep format
%
% Syntax: 
%     glypepformulaObj = glypepformula(glypepstring)
%     [glypepformulaObj,monoisomass]=glypepformula(glypepstring)
%     [monoisomass,mostabumass,glyformulastring]=glypepformula(glypepstring)
%     
% Input: 
%     glypepstring: a glycopeptide string in 'SmallGlyPep' format
%
% Output:
%     glypepformulaObj: a MATLAB Chemformula object containing the chemical 
%      formula of a glycopeptide
%     monoisomass: the monoisotopic mass of a glycopeptide
%     mostabumass: the most abundance mass of a glycopeptide
%     glyformulastring: a string representing the glycopeptide formula
%
% Examples: 
% 
%  Example 1:
%   glypepformulaObj=glypepformula('T{n{h{s}}{n{f}{h{s}}}}EPPRAM<o>M<o>D')
%   disp(glypepformulaObj.cfstruct)
%   Answer: 
%     C:98
%     H:160
%     N:16
%     O:57
%     S:2
%  
%   Example 2:
%   [monoMW,abundantMW,gform]=glypepformula('FNWY<s>VDGVM<o>VHNAK')
%   Answer:  
%     monoMW =  1774.7443259454
%     abundantMW =  1774.7443259454
%     gform = C78H110N20O24S2
%   
%   Example 3 (glycan only):
%    [monoMW,abundantMW,gform] = glypepformula('{n{n{h{h{h{h}}{h{h{h}{h{h}}}}}}}}')
%    Answer: 
%       monoMW =  1882.6447206358
%       abundantMW =  1882.6447206358
%       gform = H118O56C70N2
% 
%    [monoMW,abundantMW,gform] = glypepformula('{h{h{h{h}}{h{h{h}{h{h}}}}}}')
%    Answer:  
%       monoMW =  1476.4859755698
%       abundantMW =  1476.4859755698
%       gform = H92O46C54
%
%    [monoMW,abundantMW,gform] = glypepformula('{n{n{h{h{h{h}}}}}}')
%    Answer:  
%       monoMW =  1072.3806034783
%       abundantMW =  1072.3806034783
%       gform = H68O31C40N2
%
%   Example 4 (glycopeptide):
%    SmallGlyPep='FLPET{n{s}{h{s}}}EPPRPM<o>M<o>D';
%    [monoMW,abuntMW,gform]=glypepformula(SmallGlyPep)
%    Answer:  
%       monoMW =  2538.028844194
%       abuntMW = 2539.03151889413
%       gform = C105H163N19O49S2
%
%   [monoMW,abuntMW,gform]=glypepformula('LPET{n{s}{h{s}}}EPPRPM<o>M<o>D')
%   Answer: 
%       monoMW = 2390.9604302778
%       abuntMW = 2391.96309228327
%       gform = C96H154N18O48S2
%
%   [monoMW,abuntMW,gform]=glypepformula('FLPET{n{h}}EPPRPM<o>M<o>D')
%   Answer: 
%       monoMW = 1955.8380111386
%       abuntMW = 1956.84062942196
%       gform = C83H129N17O33S2
%
%   Example 5 
%     SmallGlyPep='VPT{n{h}}T{n{h{s}}}AASTPDAVDK';
%     [monoMW,abuntMW,gform]=glypepformula(SmallGlyPep)
%     Answer: 
%      monoMW =  2393.0479829567
%      abuntMW = 2394.05070227465
%      gform = C97H160N18O51
%
%See also ptmformula,glyformula,pepformula,glypepMW. 

%Author: Gang Liu
%Date Lastly Updated: 8/10/14
format longg
glypepformObj= Chemformula;

[pepMat,glyMat,modMat] = breakGlyPep(SmallGlyPep);

if ~isempty(pepMat)         % if it is the peptide
     pepFormula = pepformula(pepMat.pep);
     glypepformObj.add(pepFormula);    
     if ~isempty(modMat)
        for i=1:length(modMat)
            modstring = modMat(i).struct;
            modformula = ptmformula(modstring(2:end-1));
            glypepformObj.add(modformula);
        end
     end
end

for i=1:length(glyMat)      % if glycans are present
    glyForm    = glyMat(i).struct;
    glyFormula = glyformula(glyForm);
    glypepformObj.add(glyFormula);    
    
    if(~isempty(pepMat)&&~isempty(glyMat))  
       glypepformObj.sub(Chemformula(struct('H',2,'O',1)));
    end
end

if(nargout==1)
     varargout{1}   = glypepformObj;
elseif(nargout==2)
     varargout{1}   = glypepformObj;
     [MD, Info, DF] = isotopicdist(glypepformObj.cfstruct,'ShowPlot', false);
     varargout{2}   = Info.MonoisotopicMass;
elseif(nargout==3)   
     [MD, Info, DF] = isotopicdist(glypepformObj.cfstruct,'ShowPlot', false);
     varargout{1}   = Info.MonoisotopicMass;
     varargout{2}   = Info.MostAbundantMass;
     varargout{3}   = glypepformObj.tostring;     
elseif(nargout==4)   
     varargout{1}=glypepformObj;
     [MD, Info, DF] = isotopicdist(glypepformObj.cfstruct,'ShowPlot', false);
     varargout{2}=MD;
     varargout{3}=Info;
     varargout{4}=DF;
end
