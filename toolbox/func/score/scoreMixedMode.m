function CIDETDtable = scoreMixedMode(varargin)
%SCOREMIXEDMODE: Calculate new score for alternative fragmentation mode
%
% Syntax:
%   newscoretable = scoreMixedMode(scorecsvfilename,option);
%   newscoretable = scoreMixedMode(scorecsvfilename);
%
% Input:
%  scorecsvfilename: score csv file name containing decoy glycopeptide Ensemble Score
%  option: option for mixed mode calculation
%    Fields: 1) outputfilename: the file name for a new score table
%            2) glycopep: peptide (0), glycopeptide(1), or both(2)
%
% Output:
%    newscoretable: score table with the new score
%
% Example:
%    Example 1:
%      fdrdata = scoreMixedMode('testmixedmodescore.csv');
%
%    Example 2:
%      option.outputfilename = 'mixedmodescore.csv';
%      option.glycopep==0
%      fdrdata = scoreMixedMode('testresult.csv',option);
%
%See also scoreAllSpectra.

%Author: Gang Liu
%Date Lastly Updated: 11/4/14 by Gang Liu

narginchk(1,2);
if(nargin==1)
    scorecsvfilename = varargin{1};
    option.outputfilename = [];
    option.glycopep = 2;
elseif(nargin==2)
    scorecsvfilename = varargin{1};
    option = varargin{2};
end

if(~isfield(option,'glycopep'))
   option.glycopep = 2;
end

if(~isfield(option,'outputfilename'))
   option.outputfilename = [];
end


[~,~,~,scoredata] = scoreCSVread(scorecsvfilename);
scoretable = struct2table(scoredata);
if(option.glycopep==0)
    peptideonlyrows          =  cellfun('isempty',strfind(...
        scoretable.peptide,'{'));
    scoretable            =  scoretable(peptideonlyrows,:);
elseif(option.glycopep==1)
    peptideonlyrows          =  cellfun('isempty',strfind(...
        scoretable.peptide,'{'));
    scoretable            =  scoretable(~peptideonlyrows,:);
end

modetypes = unique(scoretable.fragMode);

if(length(modetypes)~=2)
    error('MATLAB:GLYCOPAT:ERROR',...
        'CURRENTLY IT SUPPORTS ONLY ALTERNATIVE CID/ETD');
else
    if isempty(strfind(upper(modetypes{1}),'CID')) && isempty(strfind(upper(modetypes{1}),'ETD'))
        error('MATLAB:GLYCOPAT:ERROR',...
            'CURRENTLY IT SUPPORTS ONLY ALTERNATIVE CID/ETD');
    end
    
    if isempty(strfind(upper(modetypes{2}),'CID')) && isempty(strfind(upper(modetypes{2}),'ETD'))
        error('MATLAB:GLYCOPAT:ERROR',...
            'CURRENTLY IT SUPPORTS ONLY ALTERNATIVE CID/ETD');
    end
end

modetypes = {'CID','ETD'};
for i = 1 : length(modetypes)
    fragmoderows{i} = ~cellfun('isempty',strfind(...
        scoretable.fragMode,modetypes{i}));
end
CIDtable = scoretable(fragmoderows{1},:);
ETDtable = scoretable(fragmoderows{2},:);

CIDETDtable=struct('CIDscan',[],'ETDscan',[],'exptMass',[],'peptide',[],...
    'charge',[],'ETDscore',[],'ETDdecoyES',[],'CIDscore',[],'CIDdecoyES',[],...
    'mixedscore',[],'decoymixedscore',[]);
cidratio = 0.7;

for i = 1 : length(CIDtable.scan)
    cidscan = CIDtable.scan(i);
    jth = find(ETDtable.scan==cidscan+1);
    if(~isempty(jth))
        if(length(jth)==1)
            CIDETDtable = constructCIDETDModel(CIDETDtable,...
                CIDtable,ETDtable,i,jth,cidratio);
        else
            for ii = 1 : length(jth)
                etdjth = jth(ii);
                CIDETDtable = constructCIDETDModel(CIDETDtable,...
                    CIDtable,ETDtable,i,etdjth,cidratio);
            end
        end
    end
end

CIDETDtable = struct2table(CIDETDtable);
if(~isempty(option.outputfilename))
    writetable(CIDETDtable,option.outputfilename);
end

end

function CIDETDtable = constructCIDETDModel(CIDETDtable,CIDtable,ETDtable,i,jth,cidratio)
if(CIDtable.exptMass(i)==ETDtable.exptMass(jth) && ...
        strcmpi(CIDtable.peptide(i),ETDtable.peptide(jth)))
    CIDETDtable.CIDscan=[CIDETDtable.CIDscan;CIDtable.scan(i)];
    CIDETDtable.ETDscan=[CIDETDtable.ETDscan;...
        ETDtable.scan(jth)];
    CIDETDtable.exptMass=[CIDETDtable.exptMass;CIDtable.exptMass(i)];
    CIDETDtable.peptide= [CIDETDtable.peptide;CIDtable.peptide(i)];
    CIDETDtable.charge=[CIDETDtable.charge;CIDtable.charge(i)];
    CIDETDtable.ETDscore=[CIDETDtable.ETDscore;ETDtable.enscore(jth)];
    CIDETDtable.CIDscore=[CIDETDtable.CIDscore;CIDtable.enscore(i)];
    CIDETDtable.ETDdecoyES=[CIDETDtable.ETDdecoyES;ETDtable.decoyES(jth)];
    CIDETDtable.CIDdecoyES=[CIDETDtable.CIDdecoyES;CIDtable.decoyES(i)];
    CIDETDtable.mixedscore=[CIDETDtable.mixedscore;...
        computeMixedESScore(CIDtable.enscore(i),ETDtable.enscore(jth),cidratio)];
    CIDETDtable.decoymixedscore = [CIDETDtable.decoymixedscore;...
        computeMixedESScore(CIDtable.decoyES(i),ETDtable.decoyES(jth),cidratio)];
end

end

function mixedscore = computeMixedESScore(cidscore,etdscore,cidratio)
mixedscore = cidscore*cidratio+etdscore*(1-cidratio);
end
