function foundPeaks=browse1mzXMLfile(varargin)
%BROWSE1MZXMLFILE: Browse the spectra stored in mzXML format 
%
% Syntax: 
%     foundPeaks = browse1mzXMLfile(filename,ithrow);
%     foundPeaks = browse1mzXMLfile(ithrow,headerpar,csvdata)
%     foundPeaks = browse1mzXMLfile(ithrow,headerpar,csvdata,mzXMLobj)
%     foundPeaks = browse1mzXMLfile(ithrow,headerpar,csvdata,mscandata)
%     foundPeaks = browse1mzXMLfile(ithrow,headerpar,csvdata,mscandata,figopt)
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
     xmlfilefullname = headerpar.xmlfilename;
     mzXMLobj        = mzXML(xmlfilefullname,0,'memsave');
     useMZXML        = 1;

elseif(nargin==3)
    ithrow     = varargin{1};
    headerpar  = varargin{2};
    data1      = varargin{3};  
    data       = scoretostruct(data1);
    xmlfilefullname = headerpar.xmlfilename;
    mzXMLobj        = mzXML(xmlfilefullname,0,'memsave');
    useMZXML        = 1;
elseif(nargin==4)
    ithrow     = varargin{1};
    headerpar  = varargin{2};
    data1      = varargin{3};  
    data       = scoretostruct(data1);
    if(isa(varargin{4},'mzXML'))
        mzXMLobj   = varargin{4};
        useMZXML   = 1;
    else
        scandata   = varargin{4};
        useMZXML   = 0;
    end
elseif(nargin==5)
    ithrow     = varargin{1};
    headerpar  = varargin{2};
    data1      = varargin{3};  
    data       = scoretostruct(data1);
    if(isa(varargin{4},'mzXML'))
        mzXMLobj   = varargin{4};
        useMZXML   = 1;
    else
        scandata   = varargin{4};
        useMZXML   = 0;
    end
    figopt  = varargin{5};
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

param(1) = maxlag;           % parameter for XCorr
param(2) = CutOffMed;        % parameters to clean Spectra
param(3) = FracMax;
nFrag(1) = nmFrag;
nFrag(2) = ngFrag;
nFrag(3) = npFrag;

scan    = data.scan;     % read scan number of file into array
MWExpt  = data.exptMass;       % read scan number of file into array
MWMono  = data.monoMass;       % read scan number of file into array
MWAbund = data.mostAbMass;       % read scan number of file into array
charge =  double(data.charge);    % read charge of corresponding file into array
sgpString=data.peptide;           % convert cell array to array of strings
Xcorr_peaklag=data.peakLag;
Xcorr_htCenter=data.htCenter;
Xcorr_Avg=data.htAvg;
percentIonMatch=data.percentIonMatch;
Pvalue=data.pValue;
decayRatio=data.decoyRatio;

save=0;
selectPeak=[];

% get spectra from mzxml file
z = charge(ithrow);
if(useMZXML)
    scannum = scan(ithrow);
    SpectraA    = mzXMLobj.retrieveMSSpectra('scannum',scannum);
else
    scannum = scan(ithrow);
    for i = 1 : length(scandata)
        if(scandata{i,1}.scannum==scannum)
            SpectraA    = scandata{i,1}.msintensitylist;
            spectraactmethod = scandata{i,1}.actmethod;
            break;
        end
    end
end
 
 if(isempty(SpectraA))
     error('MATLAB:GlycoPAT:SPECTRANOTFOUND','CAN NOT FIND SPECTRA IN XML'); 
 end
 
% Mz   = mzXMLobj.retrieveMz('scannum',scan(ithrow));
MH   = MWExpt(ithrow) + 1.007825032;  
precursorMz = (MWExpt(ithrow)+z*1.007825032)/z;
SpectraB        = [];
sgp         = sgpString{ithrow};                                    % SmallGlyPep to compare with
% 
[pepMat,glyMat,modMat]=breakGlyPep(sgp);
% 
%  % check if the spectra is the right spectra for the fragmentation mode
%  if(strcmpi(fragMode,'ETD')||strcmpi(fragMode,'ETDSpecial'))
%       actmethod = 'ETD';
%  elseif(strcmpi(fragMode,'CID')||strcmpi(fragMode,'CIDSpecial'))
%       actmethod = 'CID';               
%  elseif(strcmpi(fragMode,'HCD')||strcmpi(fragMode,'HCDSpecial'))
%       actmethod = 'HCD';
%  elseif(strcmpi(fragMode,'Auto'))
%       actmethod = 'Auto';
%  elseif(strcmpi(fragMode,'CID/HCD'))
%       actmethod =  'CID/HCD';
%  else
%       error('MATLAB:GlycoPAT:NOTSUPPORTEDFRAGMENTATION','THE FRAGMENTATION MODE IS NOT SUPPORTED');
%  end 
%  
if(strcmpi(fragMode,'Auto')) 
    if(useMZXML)
        actmetfromdata = mzXMLobj.retrieveActMethod('scannum',scan(ithrow));
    else
        actmetfromdata = spectraactmethod;
    end
   if(~isempty(strfind(upper(actmetfromdata),'ETD')))
          actmethod ='ETD';
   elseif(~isempty(strfind(upper(actmetfromdata),'CID')))
          actmethod ='CID';
   elseif(~isempty(strfind(upper(actmetfromdata),'HCD')))
          actmethod ='HCD';
   else
          actmethod ='none';
   end
  fragMode = actmethod;
end
% 
if strcmpi(fragMode,'CID') || strcmpi(fragMode,'HCD')
    nmFrag=0;
    if (~isempty(pepMat))
        npFrag=1;               % CID typically fragments peptide
    end
    if (~isempty(modMat))  % (exception: it can also fragment modification especially in the case of sulfation and phosphorylation)
       % addition of modificaiton type check
        nmFrag=0;
    end
    if (~isempty(glyMat))   % it prefers to fragment glycan instead of peptide if it is a glycopeptide
        glyNumber=0;
        for m=1:length(glyMat)
            glyNumber=glyNumber+glyMat(m).len;
        end
        if ((glyNumber<4)&&(~isempty(pepMat)))  % if number of monosaccharides <4 then we fragment on peptide backbone also once
            ngFrag=2;
            npFrag=1;
        else
            ngFrag=2;
            npFrag=0;
        end
    end
elseif strcmpi(fragMode,'ETD')
    ngFrag=0;
    nmFrag=0;
    npFrag=1;               % ETD prefers the peptide
elseif strcmpi(fragMode,'none')
    nmFrag=0;
    ngFrag=0;
    npFrag=0;
elseif strcmpi(fragMode,'CIDSpecial')
    fragMode='CIDSpecial';
elseif strcmpi(fragMode,'ETDSpecial')
    fragMode='ETDSpecial';
elseif strcmpi(fragMode,'HCDSpecial')
    fragMode='HCDSpecial';
else
    nmFrag=0;
    ngFrag=0;
    npFrag=0;
end

TempIons = multiSGPFrag(sgp,nmFrag,npFrag,ngFrag,1);        % calculate parameters for charge =1
 
if (strcmpi(fragMode,'CID')||strcmpi(fragMode,'HCD')...
    ||strcmpi(fragMode,'CIDSpecial')||strcmpi(fragMode,'HCDSpecial'))         % get rid of all c and z ions if this is CID mode
    for i = length(TempIons):-1:1
        if (~isempty(regexp(TempIons(i).type,'[cz]','once')))
            TempIons(i)=[];
        end
    end
end

ETDYION = 0;
if strcmp(fragMode,'ETD')||strcmpi(fragMode,'ETDSpecial')   % get rid of all b and y ions if this is ETD mode
    if(ETDYION)  % y ion in ETD mode considered
        for i=length(TempIons):-1:1
            if (~isempty(regexp(TempIons(i).type,'[b]','once')))
                TempIons(i)=[];
            end
        end
    else
        for i=length(TempIons):-1:1
            if (~isempty(regexp(TempIons(i).type,'[by]','once')))
                TempIons(i)=[];
            end
        end
    end    
end

selectPeak=[];
spectrascores = score1Spectrum(SpectraA,sgp,fragMode,MS2tol,MS2tolUnit,param,nFrag,selectPeak,z,MH);

if(strcmpi(fragMode,'ETD'))
     SpectraA = removePrecursorIon(SpectraA,MH,z,MS2tol,MS2tolUnit);
     SpectraA = PolishSpectraLocal(SpectraA,100,1);   % by default spannum=100 and CutOffMed=1 for ETD polishing
else
    SpectraA = PolishSpectra(SpectraA, CutOffMed, FracMax); % This program removes noise  
end 

SpectraA=deleteIsoPeaks(SpectraA,MS2tol,MS2tolUnit);

fcount=1;
SpectraC=[];
peakMatchIndex    = zeros(size(SpectraA,1),1);
peakMatchIonIndex = cell(size(SpectraA,1),1);
TempIons = sortFragIon(TempIons);

for i=1:length(TempIons)
    once=false;
    peak=0;
    for charge=1:z
        Tempmz=(TempIons(i).mz+(charge-1)*1.0078246)/charge;
       if strcmp(MS2tolUnit,'Da')
            ionCompSpectra=abs(SpectraA(:,1)-Tempmz)<=MS2tol;  % assuming this is in units of Da
        elseif(strcmpi(MS2tolUnit,'ppm')) % MS2tolUnit=ppm
            ionCompSpectra=abs(SpectraA(:,1)-Tempmz)<=MS2tol/1e6*Tempmz;
        else
            error('MATLAB:GlycoPAT:ERRORUNIT','WRONG UNIT FOR MS TOLERANCE');
        end
        
        peakMatchIndex = peakMatchIndex|ionCompSpectra;
        match = find(ionCompSpectra);
        
        if ~isempty(match)
            for k=1:length(match)
                foundPeaks(fcount).original=TempIons(i).original;  % information on what peaks were identified
                foundPeaks(fcount).sgp=TempIons(i).sgp;  % information on what peaks were identified
                foundPeaks(fcount).nmFrag=TempIons(i).nmFrag;  % information on what peaks were identified
                foundPeaks(fcount).npFrag=TempIons(i).npFrag;  % information on what peaks were identified
                foundPeaks(fcount).ngFrag=TempIons(i).ngFrag;  % information on what peaks were identified
         %       foundPeaks(fcount).mz=TempIons(i).mz;  % information on what peaks were identified
                foundPeaks(fcount).type=TempIons(i).type;  % information on what peaks were identified
                foundPeaks(fcount).charge=TempIons(i).charge;  % information on what peaks were identified
                foundPeaks(fcount).mzTheo=Tempmz;
                foundPeaks(fcount).mzExpt=SpectraA(match(k),1);
                foundPeaks(fcount).ppmError=(SpectraA(match(k),1)-Tempmz)/Tempmz*1e6;
                foundPeaks(fcount).DaError=(SpectraA(match(k),1)-Tempmz);
                foundPeaks(fcount).Intensity=SpectraA(match(k),2);
                foundPeaks(fcount).charge=charge;
                foundPeaks(fcount).peakIndex = match(k);
                foundPeaks(fcount).iontype = TempIons(i).newtype;
                fcount=fcount+1;
            end
        end
        
        for j=1:length(match)
            if(SpectraA(match(j),2)>peak)
                peak=SpectraA(match(j),2);
                SpectraB(i)=SpectraA(match(j),1);
                once=true;
            end
        end
        
        if (Tempmz<3000)  % This is the Spectra for Pvalue determination which does not depenend on peak matching
            SpectraC=[SpectraC,Tempmz];
        end
        if ((Tempmz<3000)&&(once==false)&&(isempty(match)))  % By default set to smallest charge species, provided this smallese size is <3000
            once=true;
            SpectraB(i)=Tempmz;
        end
    end
end

if(~exist('foundPeaks','var'))
    foundPeaks = [];
end

for i = 1 : length(peakMatchIonIndex)
   peakMatchIonIndex{i} =[];
   for j = 1 : length(foundPeaks)
     if(foundPeaks(j).peakIndex==i)
       peakMatchIonIndex{i}=[peakMatchIonIndex{i,1};j]; % number of peaks * 1, cell
     end
   end
end
ionFragmentMatrix =comptFragIonMatrix(sgp,TempIons,foundPeaks);
if(nargin~=5)
    spectraAnnotation(scannum,SpectraA,peakMatchIndex,peakMatchIonIndex,...
        foundPeaks,sgp,z,precursorMz,ionFragmentMatrix,spectrascores,fragMode,...
        MS2tol,MS2tolUnit);
else
    spectraAnnotation(scannum,SpectraA,peakMatchIndex,peakMatchIonIndex,...
        foundPeaks,sgp,z,precursorMz,ionFragmentMatrix,spectrascores,fragMode,...
        MS2tol,MS2tolUnit,figopt);
end
end

function ionFragPeakMatrix = comptFragIonMatrix(sgp,fragmentIons,foundPeaks)
[~,glyMat,~]= breakGlyPep(sgp);
numMonoinSGP=0;
for i = 1 : length(glyMat)
    numMonoinSGP = numMonoinSGP+ glyMat(i).len;
end

fragIonCluster.cIons=[];
fragIonCluster.zIons=[];
fragIonCluster.bIons=[];
fragIonCluster.bglycoIons=[];
fragIonCluster.yIons=[];
fragIonCluster.yglycoIons=[];
fragIonCluster.fullIons=[];
for i=1:length(fragmentIons);
    if(~isempty(regexp(fragmentIons(i).type,'c','once')))
        fragIonCluster.cIons=[fragIonCluster.cIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'z','once')))
        fragIonCluster.zIons=[fragIonCluster.zIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'b[^0-9]','once')))
        fragIonCluster.bglycoIons=[fragIonCluster.bglycoIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'b[0-9]','once')))
        fragIonCluster.bIons=[fragIonCluster.bIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'y[^0-9]','once')))
        fragIonCluster.yglycoIons=[fragIonCluster.yglycoIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'y[0-9]','once')))
        fragIonCluster.yIons=[fragIonCluster.yIons fragmentIons(i)];
    elseif(~isempty(regexp(fragmentIons(i).type,'none','once')))
        fragIonCluster.fullIons=[fragIonCluster.fullIons fragmentIons(i)];
    end
end

% for b-y ions
ionFragPeakMatrix = struct('cIons',[],'zIons',[],'bglycoIons',[],...
    'yglycoIons',[],'bIons',[],'yIons',[],'fullIons',[]);
ionfragnames = fieldnames(ionFragPeakMatrix);
for i = 1 : length(ionfragnames)
    iontype = ionfragnames{i};
    for j = 1 : length(fragIonCluster.(iontype))
        ionFragPeakMatrix.(iontype){j,1} = fragIonCluster.(iontype)(j).newtype;
        ionFragPeakMatrix.(iontype){j,2} = 0;
        for k = 1 : length(foundPeaks)
            if(strcmp(fragIonCluster.(iontype)(j).sgp,foundPeaks(k).sgp))
                ionFragPeakMatrix.(iontype){j,2} = 1;
                continue;
            end
        end
    end
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

