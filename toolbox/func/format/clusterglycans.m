function clusterglycanout = clusterglycans(pathwayinput)
% CLUSTERGLYCANs: group glycans according to their distance matrix
%
% Syntax:
%   clusterglycanout = clusterglycans(pathwayinput)
%
% Input:
%    pathwayinput: pathway Object
%
% Output:
%   clusterglycanout: n x 2 cell array, All the glycans will be clustered
%    into n groups sharing the same distnace matrix. The 1st column list
%    the representative glycans from each group in SGP format, and the 
%    2nd column contains all the glycans (GlycanSpecies objects) in each 
%    group.
%
% Example:
%    pathwayexample   = Pathway.loadmat('nglypathexample.mat'); 
%    clusterglycanout = clusterglycans(pathwayexample)
%  Answer:
%    clusterglycanout = 
%     '{n{n{h{h{n{h{s}}}}{h{n{h{s}}}{n{h{s}}}}}}}'    {1x1 cell}
%     '{n{n{h{h{n{h}}}{h{n{h{s}}}{n{h{s}}}}}}}'       {3x1 cell}
%     '{n{n{h{h{n}}{h{n{h{s}}}{n{h{s}}}}}}}'          {3x1 cell}
%     '{n{n{h{h{n}}{h{n{h}}{n{h{s}}}}}}}'             {6x1 cell}
%     '{n{n{h{h{n}}{h{n}{n{h{s}}}}}}}'                {3x1 cell}
%     '{n{n{h{h{n}}{h{n}{n{h}}}}}}'                   {3x1 cell}
%     '{n{n{h{h{n}}{h{n}{n}}}}}'                      {1x1 cell}
%     '{n{n{h{h{n}}{h{n}}}}}'                         {1x1 cell}
%     '{n{n{h{h{n}}{h}}}}'                            {1x1 cell}
%     '{n{n{h{h{n}}{h{h}}}}}'                         {1x1 cell}
%     '{n{n{h{h{n}}{h{h}{h}}}}}'                      {1x1 cell}
%     '{n{n{h{h}{h{h}{h}}}}}'                         {1x1 cell}
%     '{n{n{h{h{h}}{h{h}{h}}}}}'                      {1x1 cell}
%     '{n{n{h{h{h}}{h{h}{h{h}}}}}}'                   {1x1 cell}
%     '{n{n{h{h{h{h}}}{h{h}{h{h}}}}}}'                {1x1 cell}
%     '{n{n{h{h{h{h}}}{h{h{h}}{h{h}}}}}}'             {1x1 cell}
%     '{n{n{h{h{n}}{h{n{h}}{n{h}}}}}}'                {3x1 cell}
%     '{n{n{h{h{n{h}}}{h{n{h}}{n{h{s}}}}}}}'          {3x1 cell}
%     '{n{n{h{h{n{h}}}{h{n{h}}{n{h}}}}}}'             {1x1 cell}
%  
% Children function: glycan2distmatrix

%Author: Kai Chen
%Date Lastly Updated: 11/30/14
numspecies = length(pathwayinput.theSpecies);
ngly = cell(numspecies,1);
for i = 1 :numspecies
    itheSpecieslinucs = pathwayinput.theSpecies.get(i).glycanStruct.toLinucs;
    ngly{i}=linucs2SmallGlyPep(itheSpecieslinucs,'linucs');
end

nspecies = pathwayinput.theSpecies.get(1:numspecies);
if ~isempty(ngly)
    nglytemp = cellfun(@glycan2distmatrix,ngly,'uniformoutput',false);
    indexreshape = cellfun(@reshape,nglytemp,num2cell(ones(size(nglytemp,1),1)),...
        num2cell(ones(size(nglytemp,1),1)*numel(nglytemp{1})),'uniformoutput',false);
    [~,uniqueid,allid] = unique(indexreshape,'stable');
    nunique = cell(length(uniqueid),2);
    for i = 1:length(uniqueid)
        nunique{i,1} = ngly{uniqueid(i)};
        nunique{i,2} = nspecies(allid == i);
    end
else
    nunique = [];
end

clusterglycanout = nunique;
end
