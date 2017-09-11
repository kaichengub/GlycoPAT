function fdrdata = fdr(varargin)
%FDR: Calculate false discovery rate based on decoy data sets
%
% Syntax:
%   fdrrate = fdr(scorecsvfilename,option);
%   fdrrate = fdr(scorecsvfilename);
%
% Input:
%  scorecsvfilename: score csv file name containing decoy glycopeptide Ensemble Score
%  option: option for false discovery rate computation.
%    Fields: 1) glycopep: selection of peptide (0),glycopeptide (1) or both (2)
%            2) singlemode: consider single mode (CID/ETD/HCD) (1) or all modes (0).
% Output:
%    fdrrate: false discovery rate using different ES cutoff.
%
% Example:
%    Example 1:
%      fdrdata = fdr('testresult.csv');
%      plot (fdrdata.mixedmode (:,1), fdrdata.mixedmode (:,2))
%
%    Example 2:
%      option.glycopep = 1;
%      option.singlemode  = 0;
%      fdrdata = fdr('testresult.csv',option);
%
%    Example 3:
%      [~,~,~,~,scoretable] = scoreCSVread('testresult.csv');
%      fdrdata = fdr(scoretable);
%
%    Example 4:
%      option.glycopep = 1;
%      option.singlemode  = 0;
%      [~,~,~,~,scoretable] = scoreCSVread('testresult.csv');
%      fdrdata = fdr(scoretable,option);
% 
%See also swapAacid, glycanDecoy, fdrdecoy, fdr, fdrfiler, scorProb, Pvalue.

%Author: Gang Liu
%Date Lastly Updated: 11/4/14 by Gang Liu

narginchk(1,2);
if(nargin==1)
    scoreinput = varargin{1};
    fdroption = struct('glycopep',2,'singlemode',0);
elseif(nargin==2)
    scoreinput = varargin{1};
    fdroption = varargin{2};
end

if(ischar(scoreinput))
    [~,~,~,~,scoretable] = scoreCSVread(scoreinput);
elseif(istable(scoreinput))
    scoretable = scoreinput;
else
   error('MATLAB:GLYCOPAT:ERRORINPUT','INPUT TYPE MUST BE CHARACTER OR TABLE'); 
end

cutoffstart   = 0.05;
cutoffend     = 0.95;
scoreinterval = 0.01;

% peptide or glycopeptide
if(fdroption.glycopep==0)
    peptideonlyrows       =  cellfun('isempty',strfind(...
        scoretable.peptide,'{'));
    scoretable            =  scoretable(peptideonlyrows,:);
elseif(fdroption.glycopep==1)
    peptideonlyrows          =  cellfun('isempty',strfind(...
        scoretable.peptide,'{'));
    scoretable            =  scoretable(~peptideonlyrows,:);
end

% fragMode
modetypes = unique(scoretable.fragMode);
if(length(modetypes)==1)
    fdrdata.(upper(modetypes{1})) = computeFDRMatrix(scoretable.decoyES,...
              cutoffstart,cutoffend,scoreinterval);    
else
    if(fdroption.singlemode==1)
        for i = 1 : length(modetypes)
            fragmoderows  = ~cellfun('isempty',strfind(...
                scoretable.fragMode,modetypes{i}));
            scoresubtable = scoretable(fragmoderows,:);
            fragmodename  = modetypes{i};
            fdrdata.(fragmodename)= computeFDRMatrix(...
                scoresubtable.decoyES,cutoffstart,...
                cutoffend,scoreinterval);
        end
    else
        fdrdata.mixedmode = computeFDRMatrix(scoretable.decoyES,...
            cutoffstart,cutoffend,scoreinterval);
    end
end

end

function fdrmatrix = computeFDRMatrix(decoyES,cutoffstart,cutoffend,scoreinterval)

numpoints = ceil((cutoffend-cutoffstart)/scoreinterval);
fdrmatrix = zeros(numpoints,2);
for i =1:numpoints
    cutoff = cutoffstart+(i-1)*scoreinterval;
    fdrmatrix(i,1) = cutoff;
    numfp = length(decoyES(decoyES>=cutoff));
    fdrmatrix(i,2) = numfp/length(decoyES);
end
end
