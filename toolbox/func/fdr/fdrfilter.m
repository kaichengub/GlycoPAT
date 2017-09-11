function [escutoff,scoretable] = fdrfilter(varargin)
%FDRFILTER: Filter the PSM using false discovery rate control
%
% Syntax:
%    [escutoff,scoretablefiltered]  = fdrfilter(scorecsvfilename,option);
%    [escutoff,scoretablefiltered]  = fdrfilter(scorecsvfilename);
%    [escutoff,scoretablefiltered]  = fdrfilter(scoretable);
%    [escutoff,scoretablefiltered]  = fdrfilter(scoretable,option);
%
% Input:
%    scorecsvfilename: the csv file name containing original and decoy glycopeptide Ensemble Score
%    option: option for filter parameter.
%    Fields:
%           fdrfilter:  FDR filter rate (%: default parameter is 1%)
%           glycopep:   selection of peptide (0),glycopeptide (1) or both (2)
%           singlemode: consider single mode (CID/ETD/HCD) (1) or all modes (0).
%           fragmode: CID/ETD/HCD.
%
% Output:
%      escutoff: the cutoff value correpsonding to FDR filter
%      scoretablefiltered: score table filtered using FDR criteria
%
% Example:
%    Example 1:
%      [escutoff, filteredPSM] = fdrfilter('testresult.csv');
%
%    Example 2:
%      option             = struct('fdrfilter',0.01,'glycopep',1,'singlemode',1,'fragmode','CID');
%      [escutoff, filteredPSM]  = fdrfilter('testresult.csv',option);
%
%    Example 3:
%      [~,~,~,~,scoretable] = scoreCSVread('testresult.csv');
%      [escutoff, filteredPSM] = fdrfilter(scoretable);
%
%    Example 4:
%      [~,~,~,~,scoretable] = scoreCSVread('testresult.csv');
%      option             = struct('fdrfilter',0.01,'glycopep',1,'singlemode',1,'fragmode','CID');
%      [escutoff, filteredPSM]  = fdrfilter(scoretable,option);%
%
%See also fdr, fdrdecoy.

%Author: Gang Liu
%Date Lastly Updated: 15/5/28 by Gang Liu

narginchk(1,2);
if(nargin==1)
    scoreinput = varargin{1};
    fdroption        = struct('fdrfilter',0.01,'glycopep',1,'singlemode',0,'fragmode','CID');
elseif(nargin==2)
    scoreinput = varargin{1};
    fdroption        = varargin{2};
    if(~isfield(fdroption,'fdrfilter'))
        fdroption.fdrfilter=1;
    end
    
    if(~isfield(fdroption,'glycopep'))
        fdroption.glycopep=1;
    end
    
    if(~isfield(fdroption,'singlemode'))
        fdroption.singlemode=0;
    end
    
    if(~isfield(fdroption,'fragmode'))
        fdroption.fragmode='CID';
    end
end

% make sure fragmode is CID/ETD/HCD
if(ischar(scoreinput))
    [~,~,~,~,scoretable] = scoreCSVread(scoreinput);
elseif(istable(scoreinput))
    scoretable = scoreinput;
else
    error('MATLAB:GLYCOPAT:ERRORINPUT','INPUT TYPE MUST BE CHARACTER OR TABLE');
end

% fdr filter
fdrrate    =  fdr(scoretable,fdroption);

if(fdroption.singlemode==1)
    % fragmentation mode filter
    fragmoderows  = ~cellfun('isempty',strfind(...
        scoretable.fragMode,fdroption.fragmode));
    scoretable    = scoretable(fragmoderows,:);
end

% glycopeptide filter
if(fdroption.glycopep==0)
    peptideonlyrows       =  cellfun('isempty',strfind(...
        scoretable.peptide,'{'));
    scoretable            =  scoretable(peptideonlyrows,:);
elseif(fdroption.glycopep==1)
    peptideonlyrows          =  cellfun('isempty',strfind(...
        scoretable.peptide,'{'));
    scoretable            =  scoretable(~peptideonlyrows,:);
end
if(fdroption.singlemode==1)
    fdrvses    =  fdrrate.(fdroption.fragmode);
else
    fdrvses    =  fdrrate.mixedmode;
end
escutoff   =  findescutoff(fdrvses,fdroption.fdrfilter);
scoretable =  scoretable(scoretable.enscore>escutoff,:);

end

function escutoff=findescutoff(fdrvses,fdrfilter)
fdrcutoffdif = fdrvses(:,2)-fdrfilter;
i = 1;
cutoffindex =-1;
while(i<=length(fdrcutoffdif)-1)
    if(fdrcutoffdif(i)==0)
        escutoff = fdrvses(i,1);
        return;
    elseif(fdrcutoffdif(i)>0 && fdrcutoffdif(i+1)< 0 )
        cutoffindex=i;
        break;
    end
    i=i+1;
end
if(cutoffindex~=-1)
    slope    = (fdrvses(cutoffindex,1) - fdrvses(cutoffindex+1,1))/( fdrvses(cutoffindex,2)-fdrvses(cutoffindex+1,2));
    escutoff = fdrvses(cutoffindex,1) - slope*(fdrvses(cutoffindex,2)-fdrfilter);
else
    warning('Filter criteria is not set up properly');
    escutoff = 0;
end
end