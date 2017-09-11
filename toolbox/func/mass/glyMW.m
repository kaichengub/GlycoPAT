function gmw = glyMW(gly)
% GLYMW: Calculate monoisotopic MW of glycan (NOT M+H)
% 
% Syntax: 
%      glyFull = glyMW(glycanstring)
% 
%   Input:
%     glycanstring: Glycan string, optionally enclosed by {}
% 
%   Output: 
%     glyFull: monoisotopic glycan MW (NOT M+H)
%
% Examples: 
%  Example 1: 
%   for 'HexNAcHexNeuAc' (brackets are ignored)
%   >> glyMW('{n{h{s}}}') 
%   Answer:
%       ans=674.2381756  
%
%  Example 2:
%   for NeuAc2,3Hex2,3[NeuAc2,6]HexNAc (linkage specificity mentioned in the text is ignored) 
%    >> glyMW('{n{s}{h{s}}}')
%   Answer:
%       ans = 965.333592
%
%  Example 3 (no brackets with parentheses):
%     HexNAcHex(NeuAc)
%   >> glyMW('nh(s)'); 
%    Answer:
%       ans = 674.2381756
%
%  Example 4:
%   for FucNeuAcHexHexNAc
%    >> slex='fshn'; 
%      glyMW(strcat(slex,'hn'))
%    Answer:
%       ans = 1185.4282804
%
%See also ptm,glypepMW,pepMW,glyformula.

% Author: Gang Liu and Sriram Neelamegham
% Date Last updated : 11/26/14  by Gang Liu

% Note: Solution verification:
% Answers checked using GlycanMass

format longg;
glyMW=0;
[starting,ending]  = regexp(gly,'\d+(\.\d+)?');  % find number in string
for k=1:length(starting)
    str=(gly(starting(k):ending(k)));
    glyMW=glyMW+str2num(str);
end

typesofmono = Glycan.glycanMSMap.keys;                     
numtypesofmono = length(typesofmono);
for i = 1 : numtypesofmono
    nummonoresidues = length(strfind(gly,typesofmono{i}));
    glyMW = glyMW+nummonoresidues*Glycan.glycanMSMap(typesofmono{i});
end
gmw=glyMW+18.0105633;
end

% nHex    = strfind(gly,'h');
% glyMW   = glyMW+length(nHex)*162.0528235;  % all masses are internal glycan fragments
% nHexNAc = strfind(gly,'n');
% glyMW   = glyMW+length(nHexNAc)*203.0793724;
% nNeuAc  = strfind(gly,'s');
% glyMW   = glyMW+length(nNeuAc)*291.0954164;
% nNeuGc  = strfind(gly,'g');
% glyMW   = glyMW+length(nNeuGc)*307.0903311;
% nFuc    = strfind(gly,'f');
% glyMW   = glyMW+length(nFuc)*146.0579089;
% nXyl    = strfind(gly,'x');
% glyMW   = glyMW+length(nXyl)*132.0422588;
% nSO3    = strfind(gly,'z');                  % sulfation adds SO3 to MW
% glyMW   = glyMW+length(nSO3)*79.95681459;
% nPO3=strfind(gly,'p');                  % phosphoration adds PO3H to MW
% glyMW=glyMW+length(nPO3)*79.96633093;
% nKDN=strfind(gly,'k');
% glyMW=glyMW+length(nKDN)*250.0688675;
% nHexA=strfind(gly,'u');
% glyMW=glyMW+length(nHexA)*176.0320881;
% nHexNTGc=strfind(gly,'q');
% glyMW=glyMW+length(nHexNTGc)*(235.051431+57.02146354);  % =HexNAc+S
% ntotal=length(nHex)+length(nHexNAc)+length(nNeuAc)+length(nNeuGc)+...
%     length(nFuc)+length(nXyl)+length(nKDN)+length(nHexA)+length(nHexNTGc);