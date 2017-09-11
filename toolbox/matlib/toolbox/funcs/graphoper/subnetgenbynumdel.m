function subpathArrayList = subnetgenbynumdel(path,nspeciesToRemove,varargin)
%SUBNETGENBYNUMDEL generate a list of subpath from a pathway
%
% subpath = SUBNETGENBYNUMDEL(path,nspeciesToremove)
%   returns an array of  pathway objects by removing a number 
%   of species (nspeciesToremove) from the pathway.
%
% subpath = SUBNETGENBYNUMDEL(path,nspeciesToremove,
%   'removeiso',true) returns a Pathway object subpath where
%    isolated species are removed.
%  
%  Example: 
%        pathexample = Pathway.loadmat('nlinkedpath.mat');
%        glycanPathViewer(pathexample);
%        subpathlist = subnetgenbynumdel(pathexample,2);
%        glycanPathViewer(subpathlist.get(2));
%
%See also SUBNETGENBYSPECDEL, SUBNETGENBYSPECKEEP.

% Author: Gang Liu
% Date Last Updated: 06/07/13
if(~isa(path,'Pathway'))
    error('MATLAB:GNAT:WrongInput','Input Wrong Type');
end

if(~isnumeric(nspeciesToRemove));
    error('MATLAB:GNAT:WrongInput','Input Wrong Type');
end

if(length(varargin)==2)
    if(strcmp(varargin{1},'removeiso')&&islogical(varargin{2}))
        hasisospeciesremoved = varargin{2};
    end
else
    hasisospeciesremoved = 0;
end

% if(length(varargin)==2)
%      if(strcmp(varargin{1},'parallel')&&islogical(varargin{2}))
%            optionparrel = varargin{2};
%      end
% else
%     optionparrel = 0;
% end

subpathArrayList = CellArrayList;

% specilist index
totalNSpecies    = path.getNSpecies;
nspeciesToStay = totalNSpecies - nspeciesToRemove;
comblistindex   = combinator(totalNSpecies,nspeciesToStay,'c') ;


%% leave for parallel computing development
% if(optionparrel)
%     % check if parallel computing toolbox is installed
%      vertoolbox  = ver;
%      parrelavail = 0;
%      for i =1:length(vertoolbox)
%           toolname = vertoolbox(i);
%           if(strcmp(toolname.Name,'Parallel Computing Toolbox'))
%                parrelavail = 1;
%           end
%      end
%
%      if(~parrelavail)
%            optionparrel=0;
%      end
% end

% if(~optionparrel)
for i = 1 : length(comblistindex)
    disp(num2str(i));
    listindex = comblistindex(i,:);
    listofsubspecies = path.theSpecies.get(listindex);
    subspeciesinput = CellArrayList;
    subspeciesinput.add(listofsubspecies);
    subpathway       = subnetgenbyspeckeep(path,subspeciesinput,...
        'removeiso',hasisospeciesremoved);
    %     disp(num2str(subpathway.getNSpecies));
    %     disp(num2str(subpathway.getNReactions));
    subpathArrayList.add(subpathway);
end

% else
%         matlabpool;
%         subpathwaylist = zeros(1,length(comblistindex));
%         parfor i = 1 : length(comblistindex)
%         disp(num2str(i));
%         listindex = comblistindex(i,:);
%         listofsubspecies = path.theSpecies.get(listindex);
%         subspeciesinput = CellArrayList;
%         subspeciesinput.add(listofsubspecies);
%         subpathway       =   subnetgenbyspeckeep(path,subspeciesinput);
%         %     disp(num2str(subpathway.getNSpecies));
%         %     disp(num2str(subpathway.getNReactions));
%         subpathwaylist(i,1)=subpathway;
% end

%     for i = 1 : length(comblistindex)
%         subpathArrayList.add(subpathwaylist(i,1));
%     end
%     matlabpool close;
%     end

end

