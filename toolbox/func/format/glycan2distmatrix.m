function glycan_index = glycan2distmatrix(sgpstr)
%GLYCAN2DISTMATRIX: Retrieve an character array of digits on distance
% of each kind of monosaccharide from reducing end.
%
% Syntax:
%   glycan_index = glycan2distmatrix(sgpstr)
%
% Input:
%   sgpstr: glycan string in SGP format
%
% Output:
%   glycan_index: 20 x 31 character array, could be transferred to 20 x 11
%   matrix with str2num
%
% Note:
%    row number represents distance from connecting AA, counting by bonds,
%    column number represents monosaccharide types.
%     From column 1: Hex, HexNAc, NeuAc, NeuGc, Fuc, Xyl, SO3, PO3, KDN, HexA,
%     HexNTGc
%
% Example:
%   > glycan2distmatrix('{n{n{h{h{h{h}}}{h{h{h}}{h{h}}}}}}')
%
% ans =
%
% 0  1  0  0  0  0  0  0  0  0  0
% 0  1  0  0  0  0  0  0  0  0  0
% 1  0  0  0  0  0  0  0  0  0  0
% 2  0  0  0  0  0  0  0  0  0  0
% 3  0  0  0  0  0  0  0  0  0  0
% 3  0  0  0  0  0  0  0  0  0  0
% 0  0  0  0  0  0  0  0  0  0  0
% 0  0  0  0  0  0  0  0  0  0  0
% 0  0  0  0  0  0  0  0  0  0  0
% 0  0  0  0  0  0  0  0  0  0  0
% 0  0  0  0  0  0  0  0  0  0  0
% 0  0  0  0  0  0  0  0  0  0  0
% 0  0  0  0  0  0  0  0  0  0  0
% 0  0  0  0  0  0  0  0  0  0  0
% 0  0  0  0  0  0  0  0  0  0  0
% 0  0  0  0  0  0  0  0  0  0  0
% 0  0  0  0  0  0  0  0  0  0  0
% 0  0  0  0  0  0  0  0  0  0  0
% 0  0  0  0  0  0  0  0  0  0  0
% 0  0  0  0  0  0  0  0  0  0  0
%
% Children function: None

% Author: Kai Cheng
% Date Lastly Updated: 11/30/14
glyresiduelib = 'hnsgfxzpukq';
maxlevel = 20;
[~,glymod,~] = breakGlyPep(sgpstr);
sgpstr = glymod.struct;
indtemp = strfind(sgpstr,'{');
levelindex = zeros(2,length(sgpstr));
indtemp2 = strfind(sgpstr,'}');
levelindex(1,indtemp) = 1;
levelindex(1,indtemp2) = -1;
levelindex(2,1) = 1;
for i = 2:size(levelindex,2)
    levelindex(2,i) = levelindex(2,i-1) + levelindex(1,i);
end
letterindex = zeros(1,length(sgpstr));
letterindex(regexp(sgpstr,'[a-z]')) = 1;
index = letterindex.*levelindex(2,:);

residuelevel = zeros(maxlevel,length(glyresiduelib));
for i = 1:length(glyresiduelib);
    residueleveltemp = index(regexp(sgpstr,glyresiduelib(i)));
    if isempty(residueleveltemp)
        residueleveltemp = zeros(1,20);
    end
    residuelevel(:,i) = histc(residueleveltemp,1:20)';
end
glycan_index = num2str(residuelevel);
end

