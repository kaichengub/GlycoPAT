function [NewGlyPep,Bion]=glycanFrag(SmallGlyPep,breakPt)
%GLYCANFRAG: Break input glycan/glycopeptide at break points and return fragments 
%
% Syntax: 
%    [NewGlyPep,Bion]=glycanFrag(SmallGlyPep,breakPt)
%
% Input: SmallGlyPep and breakPt array, denoting sites of glycan fragmentation
%
% Output: New glycopeptide that is reduced in size and cell array with Bions
%   Note: If the input is purely a glycan, then NewGlyPep will correspond to the y-ion
%   formed following either single or multiple fragmentation
%
% Example 1: for glycopeptide
% >> SmallGlyPep='GYLN{n{n{h{h{h{h}}}{h{h{h}}{h{h}}}}}}CT{n{h{s}}{n{h{s}{f}}}}R';
%    breakPt=[9,13,52]
%    [NewGlyPep,glyBion]=glycanFrag(SmallGlyPep,breakPt)
% Answer:
%       breakPt =    9    13    52
%       NewGlyPep = GYLN{n{n}}CT{n{h{s}}{n{h{f}}}}R
%       glyBion = '{s}'    '{h{h}}'    '{h{h}{h{h{h}}{h{h}}}}'
%
% Example 2: for glycopeptide (with glycan and another modification on the
% same amino acid)
% >> SmallGlyPep='GYLN{n{n{h{h{h{h}}}{h{h{h}}{h{h}}}}}}CT<s>{n{h{s}}{n{h{s}{f}}}}R';
%    breakPt=[9,13,51]
%    [NewGlyPep,glyBion]=glycanFrag(SmallGlyPep,breakPt)
% Answer:
%       breakPt =    9    13    51
%       NewGlyPep = GYLN{n{n}}CT<s>{n{h{s}}}R
%       glyBion = '{n{h{s}{f}}}'    '{h{h}}'    '{h{h}{h{h{h}}{h{h}}}}' 
%
% Example 3: for glycan
% >> SmallGlyPep='{n{n{h{h{h{h}}}{h{h{h}}{h{h}}}}}}';
%    breakPt=[7,26]
%    [NewGlyPep,glyBion]=glycanFrag(SmallGlyPep,breakPt)
% Answer:
%       breakPt =    7    26
%       NewGlyPep = {n{n{h{h{h{h}}{h}}}}}
%       glyBion =    '{h}'    '{h{h{h}}}'
%
%See also UQFRAGION, JOINGLYPEP, COMPILEFRAGS,GLYCANFRAG, BREAKGLYPEP,
%MULTISGPFRAG. 

% Author: Sriram Neelamegham
% Date Lastly Updated: 8/11/14

nFrag=length(breakPt);
NewGlyPep=SmallGlyPep;
count=1;
Bion=[];
for j=nFrag:-1:1   % start with outermost bond
    openBrac=1;
    closeBrac=0;
    glyBion='{';
    NewGlyPep(breakPt(j))='';
    while(openBrac~=closeBrac)
        if (NewGlyPep(breakPt(j))=='{')
            openBrac=openBrac+1;
        end
        if (NewGlyPep(breakPt(j))=='}')
            closeBrac=closeBrac+1;
        end
        glyBion=[glyBion,NewGlyPep(breakPt(j))];
        NewGlyPep(breakPt(j))='';
    end
    Bion=[Bion,cellstr(glyBion)];
    count=count+1;
end
end