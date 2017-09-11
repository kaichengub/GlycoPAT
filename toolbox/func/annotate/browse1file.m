function browse1file(varargin)
%BROWSE1FILE: Browse the spectra
%
% Syntax:
%     foundPeaks = browse1file(filename,ithrow);
%     foundPeaks = browse1file(ithrow,headerpar,csvdata)
%     foundPeaks = browse1file(ithrow,headerpar,csvdata,mzXMLobj)
%
% Input:
%    filename: score csv file
%    ithrow: ith glycopeptide hit in CSV file
%    headpar: scoring parameter used in scoring
%    csvdata: scoring data
%    mzXMLobj: mzXML object
%
% Output:
%    foundPeaks: peaks found matching to theoretical fragment ions m/z
%    Plots that display analysis score and also display peaks that are matched.
%
%  Examples:
%     Example 1:
%         foundPeaks = browse1mzXMLfile('testscore.csv',2);
%
% Children function: PlotIt, GetData, PolishSpectra, multiSGPFrag
%
% See also browse1dtafile.

% Author: Gang Liu. Sriram Neelamegham
% Date Lastly Updated: 1/6/15 by Gang Liu
if (nargin==2)
    fname      = varargin{1};
    ithrow     = varargin{2};
    [headerpar,msdatatype,headerstr,data]=scoreCSVread(fname);
    %% mzxml specific
    if isfield(headerpar,'DataDirectory')
        mode = 'dta';
        DataDirectory = headerpar.DataDirectory;
    else
        mode = 'mzxml';
        xmlfilefullname = headerpar.xmlfilename;
        mzXMLobj        = mzXML(xmlfilefullname,0,'memsave');
        useMZXML        = 1;
    end
elseif(nargin==3)
    ithrow     = varargin{1};
    headerpar  = varargin{2};
    data1      = varargin{3};
    data       = scoretostruct(data1);
    if isfield(headerpar,'DataDirectory')
        mode = 'dta';
        DataDirectory = headerpar.DataDirectory;
    else
        mode = 'mzxml';
        xmlfilefullname = headerpar.xmlfilename;
        mzXMLobj        = mzXML(xmlfilefullname,0,'memsave');
    end
elseif(nargin==4)
    mode = 'mzxml';
    ithrow     = varargin{1};
    headerpar  = varargin{2};
    data1      = varargin{3};
    data       = scoretostruct(data1);
    mzXMLobj   = varargin{4};
else
    error('MATLAB:GLYCOPAT:ERRORINPUTNUMBER', 'INCORRECT INPUT NUMBER');
end

% Read several of the parameters from fname
fragMode   = headerpar.fragMod;
maxlag     = headerpar.mxLag;
CutOffMed  = headerpar.CutOffMed;
FracMax    = headerpar.FracMax;
MS2tolUnit = headerpar.MS2tolUnit;
MS2tol     = headerpar.MS2tol;
nmFrag     = headerpar.nmFrag;
ngFrag     = headerpar.ngFrag;
npFrag     = headerpar.npFrag;
param =[maxlag,CutOffMed,FracMax];
nFrag=[nmFrag,ngFrag,npFrag];
charge =  double(data.charge);    % read charge of corresponding file into array
z = charge(ithrow);
sgpString=data.peptide;           % convert cell array to array of strings
selectpeakstr = data.selectPeak{ithrow};
peaknum= strfind(selectpeakstr,'*');
selectPeak =[];
peaknum=[1;peaknum'];
peaknum=[peaknum;length(selectpeakstr)];
for i = 1: length(peaknum)-1
    selectpeakstr(peaknum(i)+1:peaknum(i+1)-1)
    selectPeak = [selectPeak;str2double(selectpeakstr(peaknum(i)+1:peaknum(i+1)-1))];
end
SmallGlyPep = sgpString{ithrow};
ScanNumber = data.scan(ithrow);

switch mode
    case 'dta'
        [~] = annotate1spectrum(DataDirectory,SmallGlyPep,...
            fragMode,MS2tol,MS2tolUnit,param,nFrag,selectPeak,0,...
            ScanNumber,z);
    case 'mzxml'
        [~] = annotate1spectrum(mzXMLobj,SmallGlyPep,...
            fragMode,MS2tol,MS2tolUnit,param,nFrag,selectPeak,0,...
            ScanNumber,z);
end
end

function structdata2=scoretostruct(structdata1)
fieldnames = {'protein','scan','exptMass','monoMass','mostAbMass','charge','peptide','fragMode',...
              'peakLag','htCenter','htAvg','percentIonMatch','pValue','decoyRatio',...
              'top10','selectPeak','nmFrag','ngFrag','npFrag','enscore'};

fvar = cell(1,length(structdata1));        
for i = 1 : length(fieldnames)
    for ii=1:length(structdata1)
      fvar{ii} = structdata1(ii).(fieldnames{i});
    end
    if(~isnumeric(fvar{ii}))
      structdata2.(fieldnames{i})  = fvar;
    else
       structdata2.(fieldnames{i}) = cell2mat(fvar); 
    end
end

end