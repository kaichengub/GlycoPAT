function foundPeaks=browse1dtafile(varargin)
%BROWSE1DTAFILE: Browse the spectra stored in DTA format 
%
% Syntax: 
%     foundPeaks = browse1dtafile(filename,ithrow);
%     foundPeaks = browse1dtafile(ithrow,headerpar,csvdata)
% 
% Input: 
%    filename: score csv file
%    ithrow: ith glycopeptide hit in CSV file
%    headpar: scoring parameter used in scoring 
%    csvdata: scoring data 
%  
% Output: 
%    foundPeaks: peaks found matching to theoretical fragment ions m/z
%    Plots that display analysis score and also display peaks that are matched.
%
% Children function: PlotIt, GetData, PolishSpectra, multiSGPFrag
%
% Example:
%    Example 1: 
%      foundPeaks = browse1dtafile('testdtascore.csv',1);
%
%    
%
% See also browse1dtafile. 

% Author:Gang Liu, Sriram Neelamegham
% Date Lastly Updated: 8/12/14 by Gang Liu

if (nargin==2)
    fname=varargin{1};
    ithrow=varargin{2};
    [headerpar,msdatatype,headerstr,data] = readScoreCSV(fname);
    data       = readtabulardata(fname);
    save = 0;
elseif(nargin==3)
    ithrow     = varargin{1};
    headerpar  = varargin{2};
    data1      = varargin{3};  
    data       = scoretostruct(data1);
end

% Read parameters from fname
DataDirectory = headerpar.DataDirectory;
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
nFrag=[npFrag,nmFrag,ngFrag];

ScanNumber = data.scan(ithrow);             % read scan number of file into array
MWExpt  = data.exptMass;         % read scan number of file into array
MWMono  = data.monoMass;         % read scan number of file into array
MWAbund = data.mostAbMass;       % read scan number of file into array
charge =  data.charge;           % read charge of corresponding file into array
sgpString=data.peptide;          % convert cell array to array of strings
SmallGlyPep = sgpString{ithrow};
selectpeakstr = data.selectPeak{ithrow};
peaknum= strfind(selectpeakstr,'*');
selectPeak =[];
peaknum=[1;peaknum'];
peaknum=[peaknum;length(selectpeakstr)];
for i = 1: length(peaknum)-1
    selectpeakstr(peaknum(i)+1:peaknum(i+1)-1)    
    selectPeak = [selectPeak;str2double(selectpeakstr(peaknum(i)+1:peaknum(i+1)-1))];
end

Xcorr_peaklag=data.peakLag;
Xcorr_htCenter=data.htCenter;
Xcorr_Avg=data.htAvg;
percentIonMatch=data.percentIonMatch;
Pvalue=data.pValue;
decayRatio=data.decoyRatio;

% Read names of all .dta files in DataDirectory
files=dir(DataDirectory);               % reads directory and puts it in a matlab structure
filename={files(~[files.isdir]).name}'; % reads filename from structure and puts in cell, excluding directory elements
tempfilename=[];
for j=1:length(filename)
    if regexp(char(filename(j)),'dta');   % includes only files that contain the text 'dta'
        tempfilename=[tempfilename,filename(j)];
    end
end
filename=tempfilename';

cat=strcat('.',num2str(ScanNumber),'.',num2str(charge(ithrow)));
ith = -1;
for j=1:length(filename)
    if ~isempty(strfind(char(filename{j}),cat))
        ith=j;
    end
end

if(ith==-1)
   error('MATLAB:GlycoPAT:FILENOTFOUND','CAN NOT FIND SPECTRA FILE'); 
end    
    
xfile= strcat(DataDirectory,'/',char(filename(ith)));        % Look for file in the data directory
[MH,zz,Spectra]=GetData(xfile);                             % Read data and Polish Spectra
Mz = ((MH-1.0078246)+zz*1.0078246)/zz;

% check if the spectra has fewer than 10 peaks\
 spectralengthfilter=10;
 if(length(Spectra)<=spectralengthfilter)
     error('MATLAB:GlycoPAT:SPECTRALESSTHAN10PEAKS','THE SPECTRA HAS FEWER THAN 10 PEARKS');
 end
                
 % check if the spectra is the right spectra for the fragmentation mode
 if(strcmpi(fragMode,'ETD')||strcmpi(fragMode,'ETDSpecial'))
      actmethod = 'ETD';
 elseif(strcmpi(fragMode,'CID')||strcmpi(fragMode,'CIDSpecial'))
      actmethod = 'CID' ;               
 elseif(strcmpi(fragMode,'HCD')||strcmpi(fragMode,'HCDSpecial'))
      actmethod = 'HCD';
 else
      error('MATLAB:GlycoPAT:NOTSUPPORTEDFRAGMENTATION','THE FRAGMENTATION MODE IS NOT SUPPORTED');
 end 

 fragparam = getFragParam(SmallGlyPep,actmethod,nmFrag,ngFrag,npFrag);
 nmFrag=fragparam.nmFrag;
 npFrag=fragparam.npFrag;
 ngFrag=fragparam.ngFrag;
TempIons = multiSGPFrag(SmallGlyPep,nmFrag,npFrag,ngFrag,1);        % calculate parameters for charge =1
if (strcmpi(fragMode,'CID')||strcmpi(fragMode,'HCD'))         % get rid of all c and z ions if this is CID mode
    for i = length(TempIons):-1:1
        if (~isempty(regexp(TempIons(i).type,'[cz]','once')))
            TempIons(i)=[];
        end
    end
end

ETDYION = 1;
if strcmp(fragMode,'ETD')                                   % get rid of all b and y ions if this is ETD mode
    if(ETDYION)  % y ion in ETD mode considered
        for i=length(TempIons):-1:1
            if (~isempty(regexp(TempIons(i).type,'[b]','once')))
                TempIons(i)=[];
            end
        end
    else
        for i = length(TempIons):-1:1
            if(~isempty(regexp(TempIons(i).type,'[by]','once')))
                TempIons(i)=[];
            end
        end
    end    
end

spectrascores = score1Spectrum(Spectra,SmallGlyPep,fragMode,...
    MS2tol,MS2tolUnit,param,nFrag,selectPeak,zz,MH);

if(strcmpi(fragMode,'ETD'))
    Spectra = removePrecursorIon(Spectra,MH,zz,MS2tol,MS2tolUnit);
    Spectra = PolishSpectraLocal(Spectra,100,1);   % by default spannum=100 and CutOffMed=1 for ETD polishing
else
    Spectra = PolishSpectra(Spectra, CutOffMed, FracMax); % This program removes noise  
end 

fcount=1;
peakMatchIndex    = zeros(size(Spectra,1),1);
peakMatchIonIndex = cell(size(Spectra,1),1);
TempIons          = sortFragIon(TempIons);

foundPeaks =[];
for i=1:length(TempIons)
    for charge=1:zz
        Tempmz=(TempIons(i).mz+(charge-1)*1.0078246)/charge;
       if strcmpi(MS2tolUnit,'Da')
            ionCompSpectra=abs(Spectra(:,1)-Tempmz)<=MS2tol;  % assuming this is in units of Da
        elseif(strcmpi(MS2tolUnit,'ppm')) % MS2tolUnit=ppm
            ionCompSpectra=abs(Spectra(:,1)-Tempmz)<=MS2tol/1e6*Tempmz;
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
                foundPeaks(fcount).mzExpt=Spectra(match(k),1);
                foundPeaks(fcount).ppmError=(Spectra(match(k),1)-Tempmz)/Tempmz*1e6;
                foundPeaks(fcount).DaError=(Spectra(match(k),1)-Tempmz);
                foundPeaks(fcount).Intensity=Spectra(match(k),2);
                foundPeaks(fcount).charge=charge;
                foundPeaks(fcount).peakIndex = match(k);
                foundPeaks(fcount).iontype = TempIons(i).newtype;
                fcount=fcount+1;
            end
        end
    end
end

for i = 1 : length(peakMatchIonIndex)
   peakMatchIonIndex{i} =[];
   for j = 1 : length(foundPeaks)
     if(foundPeaks(j).peakIndex==i)
       peakMatchIonIndex{i}=[peakMatchIonIndex{i,1};j]; % number of peaks * 1, cell
     end
   end
end

ionFragmentMatrix =comptFragIonMatrix(SmallGlyPep,TempIons,foundPeaks);
spectraAnnotation(ScanNumber,Spectra,peakMatchIndex,peakMatchIonIndex,...
    foundPeaks,SmallGlyPep,zz,Mz,ionFragmentMatrix,spectrascores,actmethod,...
    MS2tol,MS2tolUnit);
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
              'top10','selectPeak','nmFrag','ngFrag','npFrag','enscore','decoyES'};

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

function csvstruct = readtabulardata(fname)
fid = fopen(fname); % This is where output from matchPepList.m is stored in csv format file
if(fid==-1)
   error('MATLAB:GLYCOPAT:FILENOTFOUND','THE FILE IS NOT FOUND');
end
datatable = textscan(fid, '%s %d %f %f %f %d %s %s %d %f %f %f %f %f %f %s %d %d %d %f %f %*[^\n]','Delimiter',...
    ',','HeaderLines',10);  % reads the data from the .csv format file
fieldnames = {'protein','scan','exptMass','monoMass','mostAbMass','charge','peptide','fragMode',...
              'peakLag','htCenter','htAvg','percentIonMatch','pValue','decoyRatio',...
              'top10','selectPeak','nmFrag','ngFrag','npFrag','enscore','decoyES'};
for i = 1 : length(fieldnames)
    csvstruct.(fieldnames{i}) = datatable{i};
end    
fclose(fid);
end
