function [nProtein,startPep,endPep,headInfo]=ParsePeptideCell(pepCell)
% ParsePeptideCell: Organize data in cell array of digested peptides based
% on individual proteins
%
% Synatx: 
%    [nProtein,startPep,endPep,headInfo]=ParsePeptideCell(pepCell)
% 
% Input: 
%   pepCell: Cell array with results of digest.m
% 
% Output: 
%   nProtein: the number of proteins described in pepCell
%   startPep: starting point of individual proteins
%   endPep: ending point of each protein
%   headInfo: the header information for the digested peptide library. 
%   
% Children function: None
%
%See also DIGESTSGP. 

% Author: Sriram Neelamegham
% Date Lastly Updated: 8/11/14 by Gang Liu

nProtein=0;
for i=1:length(pepCell)
    str=char(pepCell(i));
    if (str(1)=='>')
        if (nProtein>0)
            endPep(nProtein)=i-1;
        end
        nProtein=nProtein+1;
        startPep(nProtein)=i+1;
        headInfo{nProtein}=pepCell{i}(2:end);
    end
end
endPep(nProtein)=i;
end